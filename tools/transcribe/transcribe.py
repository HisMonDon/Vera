"""Generates WebVTT captions for every lesson video in the Vera catalog.

Reads `manifest.json` (produced by build_manifest.py), downloads each video to a
local cache, transcribes it with faster-whisper, re-cuts the result into
readable caption cues, applies the physics correction map, and writes:

  coolapp/assets/captions/<topicKey>__<curriculumKey>.vtt   shipped with the app
  tools/transcribe/out/<topicKey>__<curriculumKey>.json     source for lesson copy
  tools/transcribe/report.md                                hand-correction triage

Resumable: already-written .vtt files are skipped, so an interrupted run can be
restarted without redoing work. Use --force to regenerate.

Usage (from the repo root):
    py -3.11 tools/transcribe/build_manifest.py
    py -3.11 tools/transcribe/transcribe.py
    py -3.11 tools/transcribe/transcribe.py --limit 3        # smoke test
    py -3.11 tools/transcribe/transcribe.py --check-corrections
"""

from __future__ import annotations

import argparse
import json
import pathlib
import re
import sys
import time
import urllib.request

HERE = pathlib.Path(__file__).parent
REPO = HERE.resolve().parents[1]
MANIFEST = HERE / "manifest.json"
CORRECTIONS = HERE / "corrections.yaml"
CACHE = HERE / "cache"
JSON_OUT = HERE / "out"
VTT_OUT = REPO / "coolapp" / "assets" / "captions"
REPORT = HERE / "report.md"

# Cloudflare R2 returns 403 to the default "Python-urllib" User-Agent.
USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"

# Caption shape. Broadcast convention: two lines, ~42 characters each, on screen
# long enough to read but short enough not to bury the diagram being drawn.
MAX_CUE_SECONDS = 7.0
MAX_LINE_CHARS = 42
MAX_LINES = 2
MAX_CUE_CHARS = MAX_LINE_CHARS * MAX_LINES

# Biases the decoder toward physics vocabulary. Whisper treats this as prior
# context, so naming the terms we expect to be mangled measurably helps.
INITIAL_PROMPT = (
    "This is a high school physics lesson. Terms used include: velocity, "
    "acceleration, displacement, Newton's second law, coefficient of friction, "
    "normal force, free-body diagram, Coulomb's law, electrostatic force, "
    "Kirchhoff's laws, Hooke's law, buoyancy, Archimedes' principle, "
    "Bernoulli's equation, photoelectric effect, work function, threshold "
    "frequency, Planck's constant, wave-particle duality, moment of inertia, "
    "torque, angular momentum, joules, newtons, metres per second squared."
)

# Segments below this mean log-probability get flagged for human review.
LOW_CONFIDENCE = -0.35


# --------------------------------------------------------------------------- #
# corrections
# --------------------------------------------------------------------------- #
def load_corrections() -> list[tuple[re.Pattern[str], str]]:
    if not CORRECTIONS.exists():
        return []
    import yaml  # bundled with faster-whisper's dependencies

    raw = yaml.safe_load(CORRECTIONS.read_text(encoding="utf-8")) or []
    rules: list[tuple[re.Pattern[str], str]] = []
    for i, rule in enumerate(raw):
        try:
            rules.append((re.compile(rule["pattern"], re.IGNORECASE), rule["replace"]))
        except (KeyError, re.error) as exc:
            print(f"  WARNING: corrections.yaml rule {i} is invalid: {exc}", file=sys.stderr)
    return rules


def apply_corrections(text: str, rules: list[tuple[re.Pattern[str], str]]) -> tuple[str, int]:
    n = 0
    for pattern, replacement in rules:
        text, count = pattern.subn(replacement, text)
        n += count
    return text, n


# --------------------------------------------------------------------------- #
# download
# --------------------------------------------------------------------------- #
def fetch(url: str) -> pathlib.Path:
    CACHE.mkdir(parents=True, exist_ok=True)
    name = re.sub(r"[^A-Za-z0-9._-]", "_", url.rsplit("/", 1)[-1])[:120]
    dest = CACHE / name
    if dest.exists() and dest.stat().st_size > 0:
        return dest
    req = urllib.request.Request(url, headers={"User-Agent": USER_AGENT})
    tmp = dest.with_suffix(dest.suffix + ".part")
    with urllib.request.urlopen(req, timeout=180) as response, open(tmp, "wb") as handle:
        while chunk := response.read(1 << 20):
            handle.write(chunk)
    tmp.replace(dest)  # atomic, so an interrupted download never looks complete
    return dest


# --------------------------------------------------------------------------- #
# cue segmentation
# --------------------------------------------------------------------------- #
def wrap(text: str) -> list[str]:
    """Greedy wrap into lines of at most MAX_LINE_CHARS.

    May return more than MAX_LINES; build_cues is responsible for not handing us
    more text than fits. Never breaks inside a token, so hyphenated terms like
    "free-body" stay intact.
    """
    words, lines, current = text.split(), [], ""
    for word in words:
        candidate = f"{current} {word}".strip()
        if len(candidate) <= MAX_LINE_CHARS or not current:
            current = candidate
        else:
            lines.append(current)
            current = word
    if current:
        lines.append(current)
    return lines


def join_words(tokens: list[dict]) -> str:
    """Concatenate whisper word tokens.

    Whisper carries its own leading spaces on each token, and emits hyphenated
    terms as separate tokens ("free" + "-body"). Joining with a space would turn
    that into "free -body", so we concatenate raw and only strip the ends.
    """
    return "".join(t["word"] for t in tokens).strip()


def build_cues(words: list[dict]) -> list[dict]:
    """Re-cut word timings into readable cues.

    Whisper's own segments run up to 32 seconds, which would put a whole
    paragraph on screen at once. We cut on sentence boundaries where possible and
    on the duration/line-count caps otherwise.

    Two rules keep the output clean:
      - never cut where the next token continues the current word (a leading
        hyphen), or "free-body" gets split across two cues;
      - measure length by actual wrapped line count, not a character estimate,
        so a cue can never overflow MAX_LINES.
    """
    cues: list[dict] = []
    buf: list[dict] = []

    def flush() -> None:
        if not buf:
            return
        text = join_words(buf)
        text = re.sub(r"\s+([,.!?;:])", r"\1", text)
        if text:
            cues.append({"start": buf[0]["start"], "end": buf[-1]["end"], "text": text})
        buf.clear()

    for i, word in enumerate(words):
        buf.append(word)

        nxt = words[i + 1] if i + 1 < len(words) else None
        # A token with no leading space continues the previous word.
        if nxt is not None and not nxt["word"][:1].isspace():
            continue

        text = join_words(buf)
        duration = buf[-1]["end"] - buf[0]["start"]
        lines = wrap(text)
        ends_sentence = text.endswith((".", "!", "?"))

        if ends_sentence and (len(lines) >= MAX_LINES or duration > 2.0):
            flush()
        elif len(lines) >= MAX_LINES or duration >= MAX_CUE_SECONDS:
            # If adding one more word would overflow, stop here instead.
            flush()

    flush()
    return cues


def vtt_timestamp(seconds: float) -> str:
    if seconds < 0:
        seconds = 0.0
    hours, rem = divmod(seconds, 3600)
    minutes, secs = divmod(rem, 60)
    return f"{int(hours):02d}:{int(minutes):02d}:{secs:06.3f}"


def to_vtt(cues: list[dict], title: str) -> str:
    lines = ["WEBVTT", f"NOTE {title}", ""]
    for i, cue in enumerate(cues, start=1):
        # Never let a cue's end run past the next cue's start.
        end = cue["end"]
        if i < len(cues):
            end = min(end, cues[i]["start"])
        if end <= cue["start"]:
            end = cue["start"] + 0.4
        lines.append(str(i))
        lines.append(f"{vtt_timestamp(cue['start'])} --> {vtt_timestamp(end)}")
        lines.extend(wrap(cue["text"])[:MAX_LINES])
        lines.append("")
    return "\n".join(lines)


# --------------------------------------------------------------------------- #
# main
# --------------------------------------------------------------------------- #
def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--model", default="medium.en")
    parser.add_argument("--limit", type=int, default=0, help="only the first N lessons")
    parser.add_argument("--force", action="store_true", help="regenerate existing .vtt")
    parser.add_argument("--threads", type=int, default=10)
    parser.add_argument("--check-corrections", action="store_true")
    args = parser.parse_args()

    rules = load_corrections()

    if args.check_corrections:
        samples = [
            "the coulombs law equation states",
            "v naught squared plus two a delta x",
            "8.99 newtons meters squared",
            "kirchoffs law and hookes law",
            "total internal refraction of light",
            "draw a free body diagram",
        ]
        print(f"{len(rules)} correction rules loaded\n")
        for s in samples:
            fixed, n = apply_corrections(s, rules)
            print(f"  {s!r}\n    -> {fixed!r}  ({n} applied)\n")
        return 0

    if not MANIFEST.exists():
        print("ERROR: manifest.json missing. Run build_manifest.py first.", file=sys.stderr)
        return 1

    lessons = json.loads(MANIFEST.read_text(encoding="utf-8"))
    if args.limit:
        lessons = lessons[: args.limit]

    JSON_OUT.mkdir(parents=True, exist_ok=True)
    VTT_OUT.mkdir(parents=True, exist_ok=True)

    from faster_whisper import WhisperModel

    print(f"loading {args.model} (int8, {args.threads} threads) ...", flush=True)
    t0 = time.time()
    model = WhisperModel(args.model, device="cpu", compute_type="int8", cpu_threads=args.threads)
    print(f"  ready in {time.time() - t0:.1f}s\n", flush=True)

    report_rows: list[dict] = []
    total_audio = 0.0
    started = time.time()
    # A few lessons (Sample Videos) point at the same file as a real lesson.
    # Transcribe each distinct video once; each lesson still gets its own .vtt.
    transcribed: dict[str, tuple[list[dict], list[dict], float]] = {}

    for i, lesson in enumerate(lessons, start=1):
        key = f"{lesson['topicKey']}__{lesson['curriculumKey']}"
        vtt_path = VTT_OUT / f"{key}.vtt"
        json_path = JSON_OUT / f"{key}.json"

        head = f"[{i}/{len(lessons)}] {key}"
        if vtt_path.exists() and not args.force:
            print(f"{head}  SKIP (already generated)", flush=True)
            if json_path.exists():
                report_rows.append(json.loads(json_path.read_text(encoding="utf-8"))["report"])
            continue

        print(f"{head}", flush=True)
        try:
            media = fetch(lesson["videoLink"])
        except Exception as exc:  # noqa: BLE001 - a bad URL must not kill the batch
            print(f"    DOWNLOAD FAILED: {exc}", flush=True)
            report_rows.append({"key": key, "title": lesson["title"], "error": str(exc)})
            continue

        cached = transcribed.get(lesson["videoLink"])
        if cached is not None:
            words, seg_meta, duration = cached
            print("    reusing transcript (same video as an earlier lesson)", flush=True)
        else:
          try:
            segments, info = model.transcribe(
                str(media),
                beam_size=5,
                language="en",
                initial_prompt=INITIAL_PROMPT,
                vad_filter=True,
                word_timestamps=True,
            )
            words: list[dict] = []
            seg_meta: list[dict] = []
            for seg in segments:
                seg_meta.append(
                    {
                        "start": seg.start,
                        "end": seg.end,
                        "text": seg.text.strip(),
                        "avg_logprob": seg.avg_logprob,
                    }
                )
                for w in seg.words or []:
                    words.append({"word": w.word, "start": w.start, "end": w.end})
            duration = info.duration
            transcribed[lesson["videoLink"]] = (words, seg_meta, duration)
          except Exception as exc:  # noqa: BLE001
            print(f"    TRANSCRIBE FAILED: {exc}", flush=True)
            report_rows.append({"key": key, "title": lesson["title"], "error": str(exc)})
            continue

        cues = build_cues(words)
        corrections_applied = 0
        for cue in cues:
            cue["text"], n = apply_corrections(cue["text"], rules)
            corrections_applied += n

        vtt_path.write_text(to_vtt(cues, lesson["title"]), encoding="utf-8")

        low = [s for s in seg_meta if s["avg_logprob"] < LOW_CONFIDENCE]
        row = {
            "key": key,
            "title": lesson["title"],
            "topicKey": lesson["topicKey"],
            "duration": duration,
            "cues": len(cues),
            "corrections": corrections_applied,
            "lowConfidenceSegments": len(low),
            "worstLogprob": min((s["avg_logprob"] for s in seg_meta), default=0.0),
            "flagged": [
                {"start": s["start"], "logprob": s["avg_logprob"], "text": s["text"]}
                for s in sorted(low, key=lambda s: s["avg_logprob"])[:5]
            ],
        }
        report_rows.append(row)

        json_path.write_text(
            json.dumps(
                {
                    "lesson": lesson,
                    "segments": seg_meta,
                    "cues": cues,
                    "report": row,
                },
                indent=1,
            ),
            encoding="utf-8",
        )

        total_audio += duration
        elapsed = time.time() - started
        print(
            f"    {duration / 60:.1f} min audio | {len(cues)} cues | "
            f"{corrections_applied} corrections | {len(low)} low-confidence | "
            f"elapsed {elapsed / 60:.0f} min",
            flush=True,
        )

    write_report(report_rows, args.model)
    print(f"\ndone. {total_audio / 60:.0f} min audio in {(time.time() - started) / 60:.0f} min wall")
    print(f"VTT   -> {VTT_OUT}")
    print(f"report-> {REPORT}")
    return 0


def write_report(rows: list[dict], model: str) -> None:
    ok = [r for r in rows if "error" not in r]
    failed = [r for r in rows if "error" in r]
    ok.sort(key=lambda r: r.get("worstLogprob", 0.0))

    lines = [
        "# Caption review queue",
        "",
        f"Model: `{model}`. Generated by `tools/transcribe/transcribe.py`.",
        "",
        "Auto-captions are least reliable exactly where the physics lives: dictated",
        "equations, named laws, and units. This queue ranks lessons by the model's own",
        "confidence so review effort goes where it is most likely to be needed.",
        "",
        "**Reviewing is not optional.** A caption that misstates a formula is worse than",
        "no caption. Fix the `.vtt` files in `coolapp/assets/captions/` directly; add any",
        "error you see more than once to `corrections.yaml` instead.",
        "",
    ]

    if failed:
        lines += ["## Failed", ""]
        lines += [f"- `{r['key']}` — {r['error']}" for r in failed]
        lines += [""]

    total_flagged = sum(r["lowConfidenceSegments"] for r in ok)
    lines += [
        "## Summary",
        "",
        f"- Lessons captioned: **{len(ok)}**",
        f"- Total audio: **{sum(r['duration'] for r in ok) / 3600:.1f} h**",
        f"- Cues written: **{sum(r['cues'] for r in ok)}**",
        f"- Corrections auto-applied: **{sum(r['corrections'] for r in ok)}**",
        f"- Segments flagged for review: **{total_flagged}**",
        "",
        "## Review queue (worst confidence first)",
        "",
        "| Lesson | Topic | Min | Cues | Fixed | Flagged | Worst |",
        "|---|---|---|---|---|---|---|",
    ]
    for r in ok:
        lines.append(
            f"| {r['title']} | `{r['topicKey']}` | {r['duration'] / 60:.0f} | {r['cues']} | "
            f"{r['corrections']} | {r['lowConfidenceSegments']} | {r['worstLogprob']:+.2f} |"
        )

    lines += ["", "## Flagged passages", ""]
    for r in ok:
        if not r["flagged"]:
            continue
        lines += [f"### {r['title']}  (`{r['key']}`)", ""]
        for f in r["flagged"]:
            ts = f"{int(f['start']) // 60}:{int(f['start']) % 60:02d}"
            lines.append(f"- **{ts}** ({f['logprob']:+.2f}) — {f['text']}")
        lines.append("")

    REPORT.write_text("\n".join(lines), encoding="utf-8")


if __name__ == "__main__":
    raise SystemExit(main())
