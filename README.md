# Vera

**Vera** is an online physics learning platform built from a single Flutter codebase that ships to the web, Windows, macOS, Linux, Android and iOS. 

It organises a growing library of hand-made physics lessons by course (IB Physics HL and SL, AP Physics 1 and 2, and Ontario Grade 11 and 12 Physics) and by topic. Selected lessons have captions and a seekable transcript; an animated pixel-art companion named Vera guides students through the app. 

Live at [veraphysics.com](https://veraphysics.com).

<img width="1917" height="980" alt="image" src="https://github.com/user-attachments/assets/9a714454-bc8a-47dc-b265-07ad4b6818b1" />

## Why I Built Vera

I started Vera because I struggled to find accessible physics explanations that matched what I was learning, and I saw other students looking for the same kind of help in Physics Club. I began recording lessons and built a free platform where students could find them by course and topic. I also spoke with the head of my school's physics department about how to organise the content across curricula.

I later interviewed students about the concepts they found difficult and asked them to work through physics questions, use Vera, and explain their reasoning on follow-up questions. Their feedback showed me problems I had missed while building it: some students wanted to revisit parts of the narration, and others needed more context before starting a lesson. I added lesson overviews and a seekable transcript for captioned videos, and built a captioning pipeline to extend that support to more lessons. Vera has grown through making lessons, watching how students use them, and revising the platform in response.

## Core Philosophy: One Lesson, Every Curriculum

Physics is the same physics whether a student is sitting IB, AP or the Ontario curriculum. What differs is which units each course covers. Vera records every lesson once, tags it by topic, and uses a central curriculum filter table to select lessons for each course. The catalog keeps lessons reusable across courses; adding a lesson begins with one entry, with an extra filter update when a course specifies individual lessons (see [Adding a Lesson](#adding-a-lesson)).

<img width="1917" height="976" alt="image" src="https://github.com/user-attachments/assets/58c99a69-f309-4cc1-9a2f-e84616fa46fc" />


## Features

- **Cross-Platform Flutter App:** One Dart codebase for web, desktop and mobile.
- **Six Courses, Fifteen Physics Topics:** Introductory physics, kinematics, dynamics, work and energy, momentum and collisions, harmonics, thermal physics, electricity, magnetism, electrostatics, rotational motion, fluids, optics, light and modern physics.
- **Curriculum-Aware Filtering:** Shared topic pages display only the lessons in the active course, keyed by stable course IDs so renaming a course can never silently unfilter it.
- **Deep-Linkable Lessons:** Beamer routes such as `/videos/watch/:topicKey/:curriculumKey` resolve directly from the video catalog without building the widget tree first.
- **Automatic Caption Pipeline:** A faster-whisper tool generates broadcast-style WebVTT captions for cataloged lessons, with a physics-specific correction map and a confidence-ranked review queue. Caption coverage is being expanded.
- **Seekable Transcript Panel:** For lessons with captions, a collapsible transcript under the player lets students re-read and jump to a sentence, added after testers found the narration hard to follow.
- **Lesson Overviews:** Each lesson has a summary page describing what it covers and its prerequisites, with per-topic defaults and per-video overrides.
- **Vera the Companion:** A sprite-sheet animated pet with nine animations (idle, running left, running right, waving, jumping, waiting, working, review, failed) that reacts across the home, onboarding, profile and settings pages.
- **Lightweight Auth:** Firebase Authentication and Firestore through their REST APIs, with token refresh, persisted sessions, per-user theme and recently watched lessons.
- **Locked-Down Data:** Firestore rules let each user read and write only their own profile, restrict writes to three whitelisted fields and bound their sizes. Everything else is denied.
- **Continuous Deployment:** Every push to `main` builds the web app with a strict CSP and deploys it to GitHub Pages.

<img width="1917" height="982" alt="image" src="https://github.com/user-attachments/assets/09de28a0-d033-498a-97d9-9f822061b9d6" />


## Architecture

### App

| Component | Description |
| --- | --- |
| `app/lib/main.dart` | App entry point, theming and router setup. |
| `app/lib/locations.dart` | Beamer route definitions, including deep links to individual lessons. |
| `app/lib/views/widget_tree.dart` | The app shell and navigation. |
| `app/lib/views/pages/videos/video_player.dart` | Lesson playback with captions. |
| `app/lib/views/pages/videos/lesson_summary_content.dart` | Lesson overview text, with per-topic and per-video overrides. |
| `app/lib/widgets/transcript_panel.dart` | Collapsible, seekable transcript. |
| `app/lib/widgets/pet.dart` | Vera, the animated sprite companion. |
| `app/lib/services/auth_service.dart` | Firebase Auth and Firestore over REST, token storage and refresh. |
| `app/lib/services/caption_loader.dart` | Loads bundled WebVTT caption files from `app/assets/captions/`. |

### Lesson Catalog

All paths below are relative to `app/lib/views/pages/videos/physics_videos/`.

| Component | Description |
| --- | --- |
| `video_catalog.dart` | Single source of truth for looking up any lesson by `topicKey` and `curriculumKey`. |
| `course_registry.dart` | Course identity: stable keys, display names, artwork and descriptions. |
| `curriculum_topic_filters.dart` | Which topics and lessons belong to which course. |
| `topic_registry.dart` | Maps each topic key to its page. |
| `physics_topics/` | One file per topic listing its lessons (title, video URL, curriculum key). |
| `physics_courses/` | One page per course. |

### Tooling and Infrastructure

| Component | Description |
| --- | --- |
| `tools/transcribe/` | Caption generation: manifest builder, transcriber, corrections and review report. |
| `firestore.rules` | Per-user, field-whitelisted Firestore security rules. |
| `.firebaserc` | The Firebase project the CLI deploys to. |
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

## Adding a Lesson

Add one map to the `videos` list in the topic's file under `physics_topics/`. For example, in `fluids.dart`:

```dart
{
  'curriculumKey': 'fluids_viscosity',
  'title': 'Viscosity and Drag',
  'description': 'Viscous flow, Stokes\' law and terminal velocity in fluids',
  'videoLink': 'https://pub-56767059a1844d06818006869a91df08.r2.dev/viscosity.mp4',
  // Optional overrides for the lesson overview page:
  // 'covered': '...',
  // 'prerequisites': '...',
},
```

That entry makes the lesson routable at `/videos/watch/fluids/fluids_viscosity` and visible to every course that includes the whole topic. If a course filters the topic to specific lessons, add the new `curriculumKey` to that course's set in `curriculum_topic_filters.dart`.

Then generate its captions from the repository root. Existing captions are skipped, so only the new lesson is transcribed:

```bash
python3.11 tools/transcribe/build_manifest.py
python3.11 tools/transcribe/transcribe.py
```

The new `app/assets/captions/fluids__fluids_viscosity.vtt` is picked up by the player automatically.

## Quick Start

### Requirements

- Flutter (stable channel, Dart 3.3.4 or newer)
- A Firebase project with Email/Password authentication and Firestore (see [Using Your Own Firebase Project](#using-your-own-firebase-project))

### Run the App

```bash
cd app
flutter pub get
flutter run -d chrome --dart-define=FIREBASE_API_KEY=your-web-api-key
```

Replace `chrome` with `windows`, `macos`, `linux` or a connected device to run elsewhere.

### Using Your Own Firebase Project

The web API key is passed in at build time through `--dart-define=FIREBASE_API_KEY`. The project ID (`vera-a4111`) is hardcoded in two places, which both need changing to point at another project:

- `.firebaserc`, which the Firebase CLI deploys rules to.
- The Firestore REST URLs in `app/lib/services/auth_service.dart` (`projects/vera-a4111/databases/(default)/...`).

Then deploy the rules to your project with `firebase deploy --only firestore:rules`.

### Test and Build

From `app/`:

```bash
flutter test
flutter build web --release --csp --dart-define=FIREBASE_API_KEY=your-web-api-key
```

### Regenerate Captions

Requires Python 3.11 and faster-whisper. Run from the repository root. On macOS and Linux:

```bash
python3.11 tools/transcribe/build_manifest.py
python3.11 tools/transcribe/transcribe.py              # add --limit 3 for a smoke test
python3.11 tools/transcribe/transcribe.py --check-corrections
```

On Windows, replace `python3.11` with `py -3.11`.

### Deploy

Pushing to `main` deploys the web build to GitHub Pages automatically through GitHub Actions (the `FIREBASE_API_KEY` repository secret must be set). Firestore rules are deployed with `firebase deploy --only firestore:rules`.

## License

The source code is released under the [MIT License](LICENSE).

The lesson videos and their captions (`app/assets/captions/`) are not covered by the MIT License. They are © 2026 Chenyu Lu, all rights reserved.
