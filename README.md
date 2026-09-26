# Vera

**Vera** is an online physics learning platform built from a single Flutter codebase that ships to the web, Windows, macOS, Linux, Android and iOS. It organises a growing library of hand-made physics lessons by course (IB Physics HL and SL, AP Physics 1 and 2, and Ontario Grade 11 and 12 Physics) and by topic, with auto-generated captions, a seekable transcript and an animated pixel-art companion named Vera. Live at [veraphysics.com](https://veraphysics.com).

## Core Philosophy: One Lesson, Every Curriculum

Physics is the same physics whether a student is sitting IB, AP or the Ontario curriculum. What differs is which units each course covers. Vera records every lesson once, tags it by topic, and uses a central curriculum filter table to show each student exactly the lessons their course requires, and nothing it does not. Everything else, from captions to deep links, is built so that adding a lesson is a one-line catalog entry.

## Key Milestones Completed

- [x] **Cross-Platform Flutter App:** One Dart codebase for web, desktop and mobile, with a Windows installer built through Inno Setup.
- [x] **Six Courses, Fifteen Physics Topics:** Introductory physics, kinematics, dynamics, work and energy, momentum and collisions, harmonics, thermal physics, electricity, magnetism, electrostatics, rotational motion, fluids, optics, light and modern physics.
- [x] **Curriculum-Aware Filtering:** Shared topic pages display only the lessons in the active course, keyed by stable course IDs so renaming a course can never silently unfilter it.
- [x] **Deep-Linkable Lessons:** Beamer routes such as `/videos/watch/:topicKey/:curriculumKey` resolve directly from the video catalog without building the widget tree first.
- [x] **Automatic Caption Pipeline:** A faster-whisper tool transcribes every lesson into broadcast-style WebVTT captions with a physics-specific correction map and a confidence-ranked review queue.
- [x] **Seekable Transcript Panel:** A collapsible transcript under the player lets students re-read and jump to any sentence, added after testers found the narration hard to follow.
- [x] **Lesson Overviews:** Each lesson has a summary page describing what it covers and its prerequisites, with per-topic defaults and per-video overrides.
- [x] **Vera the Companion:** A sprite-sheet animated pet with nine animations (idle, running, waving, jumping, waiting, working, review, failed) that reacts across the home, onboarding and profile pages.
- [x] **Lightweight Auth:** Firebase Authentication and Firestore through their REST APIs, with token refresh, persisted sessions, per-user theme and recently watched lessons.
- [x] **Locked-Down Data:** Firestore rules let each user read and write only their own profile, restrict writes to three whitelisted fields and bound their sizes. Everything else is denied.
- [x] **Continuous Deployment:** Every push to `main` builds the web app with a strict CSP and deploys it to GitHub Pages.

## Architecture

| Component | Description |
| --- | --- |
| `coolapp/lib/main.dart` | App entry point, theming and router setup. |
| `coolapp/lib/locations.dart` | Beamer route definitions, including deep links to individual lessons. |
| `coolapp/lib/views/widget_tree.dart` | The app shell and navigation. |
| `.../physics_videos/video_catalog.dart` | Single source of truth for looking up any lesson by `topicKey` and `curriculumKey`. |
| `.../physics_videos/course_registry.dart` | Course identity: stable keys, display names, artwork and descriptions. |
| `.../physics_videos/curriculum_topic_filters.dart` | Which topics and lessons belong to which course. |
| `.../physics_videos/physics_topics/` | One file per topic listing its lessons (title, video URL, curriculum key). |
| `coolapp/lib/views/pages/videos/video_player.dart` | Lesson playback with captions. |
| `coolapp/lib/widgets/transcript_panel.dart` | Collapsible, seekable transcript. |
| `coolapp/lib/widgets/pet.dart` | Vera, the animated sprite companion. |
| `coolapp/lib/services/auth_service.dart` | Firebase Auth and Firestore over REST, token storage and refresh. |
| `coolapp/lib/services/caption_loader.dart` | Loads bundled WebVTT caption files. |
| `tools/transcribe/` | Caption generation: manifest builder, transcriber, corrections and review report. |
| `firestore.rules` | Per-user, field-whitelisted Firestore security rules. |
| `.github/workflows/deploy.yml` | Web build and GitHub Pages deployment. |

## Under the Hood

### The Caption Pipeline

Auto-captions are least reliable exactly where the physics lives: dictated equations, named laws and units. The pipeline is built around that:

1. **Manifest:** `build_manifest.py` parses the Dart catalog so the list of lessons to caption can never drift from the app.
2. **Transcribe:** `transcribe.py` downloads each lesson and runs faster-whisper with an initial prompt that primes it with physics vocabulary (Coulomb's law, Kirchhoff's laws, moment of inertia and so on).
3. **Re-cut:** Output is reshaped into readable cues of at most two 42-character lines and seven seconds.
4. **Correct:** `corrections.yaml` applies ordered, whole-word fixes for systematic errors ("v naught", "kirchoff", "hookes law").
5. **Triage:** `report.md` ranks lessons by the model's own confidence so human review goes where it is most needed.

The run is resumable, skipping lessons that already have captions unless `--force` is passed.

### Why Stable Course Keys

The curriculum filter table used to be keyed by display name, and a lookup miss fell through to "allow every unit". Renaming a course, a pure copy change, silently showed students lessons their course does not cover. Courses now have stable keys that are never rendered, and tests assert that every topic and course is covered.

## Quick Start

### Requirements

- Flutter (stable channel, Dart 3.3.4 or newer)
- A Firebase project with Email/Password authentication and Firestore

### Run the App

```bash
cd coolapp
flutter pub get
flutter run -d chrome --dart-define=FIREBASE_API_KEY=your-web-api-key
```

Replace `chrome` with `windows`, `macos`, `linux` or a connected device to run elsewhere.

### Test and Build

```bash
flutter test
flutter build web --release --csp --dart-define=FIREBASE_API_KEY=your-web-api-key
```

### Regenerate Captions

Requires Python 3.11 and faster-whisper. Run from the repository root:

```bash
py -3.11 tools/transcribe/build_manifest.py
py -3.11 tools/transcribe/transcribe.py              # add --limit 3 for a smoke test
py -3.11 tools/transcribe/transcribe.py --check-corrections
```

### Deploy

Pushing to `main` deploys the web build to GitHub Pages automatically (the `FIREBASE_API_KEY` repository secret must be set). Firestore rules are deployed with `firebase deploy --only firestore:rules`.

---

2026 Copyright Chenyu Lu
