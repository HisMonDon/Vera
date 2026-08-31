"""Builds the transcription manifest by reading the Dart video catalog.

The manifest is generated, never hand-maintained, so it cannot drift from the
app. Every video the app can play is a video we generate captions for.

Run from the repo root:  py -3.11 tools/transcribe/build_manifest.py
"""

from __future__ import annotations

import json
import pathlib
import re
import sys

REPO = pathlib.Path(__file__).resolve().parents[2]
PHYSICS = REPO / "coolapp" / "lib" / "views" / "pages" / "videos" / "physics_videos"
TOPICS_DIR = PHYSICS / "physics_topics"
FILTERS = PHYSICS / "curriculum_topic_filters.dart"
OUT = pathlib.Path(__file__).parent / "manifest.json"

# static const String kinematics = 'kinematics';
RE_KEY_CONST = re.compile(r"static const String (\w+) = '([^']+)';")
# static const String _topicKey = CurriculumTopicFilters.dynamics;
RE_TOPIC_KEY = re.compile(r"static const String _topicKey = CurriculumTopicFilters\.(\w+);")
# One entry inside the `videos` list.
RE_FIELD = re.compile(r"'(\w+)':\s*(?:'((?:[^'\\]|\\.)*)'|\"((?:[^\"\\]|\\.)*)\")")


def dart_string(raw: str) -> str:
    """Unescape a Dart single/double-quoted string body."""
    return raw.replace("\\'", "'").replace('\\"', '"').replace("\\\\", "\\")


def videos_block(source: str) -> str | None:
    """Extract the body of `static const List<Map<String, dynamic>> videos = [...]`."""
    anchor = source.find("videos = [")
    if anchor == -1:
        return None
    start = source.index("[", anchor)
    depth = 0
    for i in range(start, len(source)):
        if source[i] == "[":
            depth += 1
        elif source[i] == "]":
            depth -= 1
            if depth == 0:
                return source[start + 1 : i]
    return None


def parse_entries(block: str) -> list[dict[str, str]]:
    """Split a Dart list body into per-map dictionaries."""
    entries: list[dict[str, str]] = []
    depth = 0
    buf: list[str] = []
    for ch in block:
        if ch == "{":
            depth += 1
            if depth == 1:
                buf = []
                continue
        elif ch == "}":
            depth -= 1
            if depth == 0:
                raw = "".join(buf)
                fields = {
                    m.group(1): dart_string(m.group(2) if m.group(2) is not None else m.group(3))
                    for m in RE_FIELD.finditer(raw)
                }
                entries.append(fields)
                continue
        if depth >= 1:
            buf.append(ch)
    return entries


def main() -> int:
    if not FILTERS.exists():
        print(f"ERROR: cannot find {FILTERS}", file=sys.stderr)
        return 1

    filters_src = FILTERS.read_text(encoding="utf-8")
    const_to_key = {m.group(1): m.group(2) for m in RE_KEY_CONST.finditer(filters_src)}

    rows: list[dict[str, str]] = []
    skipped: list[str] = []

    for dart in sorted(TOPICS_DIR.glob("*.dart")):
        if dart.name == "topic_widgets.dart":
            continue
        source = dart.read_text(encoding="utf-8")

        m = RE_TOPIC_KEY.search(source)
        if not m:
            skipped.append(f"{dart.name}: no _topicKey")
            continue
        topic_key = const_to_key.get(m.group(1))
        if not topic_key:
            skipped.append(f"{dart.name}: unknown constant {m.group(1)}")
            continue

        block = videos_block(source)
        if block is None:
            skipped.append(f"{dart.name}: no videos list")
            continue

        for entry in parse_entries(block):
            link = entry.get("videoLink", "")
            ckey = entry.get("curriculumKey", "")
            if not link or not ckey:
                skipped.append(f"{dart.name}: entry missing key/link ({entry.get('title', '?')})")
                continue
            rows.append(
                {
                    "topicKey": topic_key,
                    "curriculumKey": ckey,
                    "title": entry.get("title", ""),
                    "videoLink": link,
                    "source": dart.name,
                }
            )

    # Two topics can legitimately reuse the same video file (Sample Videos
    # mirrors real lessons), so dedupe on the URL for download purposes but keep
    # every topic/curriculum pair — each needs its own .vtt next to its lesson.
    seen: set[tuple[str, str]] = set()
    unique: list[dict[str, str]] = []
    dupes: list[str] = []
    for r in rows:
        pair = (r["topicKey"], r["curriculumKey"])
        if pair in seen:
            dupes.append(f"{pair[0]}/{pair[1]}")
            continue
        seen.add(pair)
        unique.append(r)

    OUT.write_text(json.dumps(unique, indent=1), encoding="utf-8")

    distinct_urls = len({r["videoLink"] for r in unique})
    print(f"manifest: {len(unique)} lessons across {len({r['topicKey'] for r in unique})} topics")
    print(f"          {distinct_urls} distinct video files to download")
    if dupes:
        print(f"  duplicate topic/curriculum pairs skipped: {dupes}")
    if skipped:
        print("  skipped:")
        for s in skipped:
            print(f"    {s}")
    print(f"wrote {OUT}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
