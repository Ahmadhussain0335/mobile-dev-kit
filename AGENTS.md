# mobile-dev-kit

Agent Skills for Android, iOS and Flutter development. Each skill is a folder under `skills/` with a
`SKILL.md` (instructions) and optional `references/*.md` (loaded on demand). Load a skill when the task
matches its description; read its references only when the skill's workflow points to them.

## Skills

| Skill | Use it for |
|---|---|
| `skills/mobile-code-review` | Reviewing Kotlin, Java, Swift and Dart diffs: correctness, concurrency, leaks, UI performance |
| `skills/mobile-security` | OWASP MASVS v2 and Mobile Top 10 audits, secure storage, TLS, IPC, GDPR / CRA / EN 18031 notes |
| `skills/mobile-ci-cd` | GitHub Actions and GitLab CI for Android, iOS and Flutter, signing, store upload, pipeline hardening |
| `skills/mobile-merge-request` | Branch naming, Conventional Commits, MR descriptions, rebasing, conflicts, review etiquette |
| `skills/mobile-mvvm` | MVVM with Compose + StateFlow, LiveData, SwiftUI + @Observable, Riverpod |
| `skills/mobile-mvi` | MVI with intents, pure reducers, side effects, Bloc, Swift stores |
| `skills/mobile-mvc` | UIKit MVC, Massive View Controller fixes, Android MVP, migration to MVVM |
| `skills/mobile-design-patterns` | Repository, Strategy, State machine, Coordinator, Result types and when not to use them |
| `skills/mobile-kotlin` | Idiomatic Kotlin 2.x, coroutines, Flow, Compose, Hilt, Room, Gradle, tests |
| `skills/mobile-java` | Java 17/21 on Android, leak-free threading, LiveData, interop and migration to Kotlin |
| `skills/mobile-swift` | Swift 6 concurrency, SwiftUI, SwiftData, SPM, Swift Testing |
| `skills/mobile-flutter` | Dart 3, Flutter widgets, Riverpod or Bloc, go_router, Pigeon, tests |

## Working on this repository

- `skills/` is the single source of truth. Tool manifests (`.claude-plugin/`, `.codex-plugin/`,
  `.cursor-plugin/`, `.agents/plugins/`, `plugin.json`, `gemini-extension.json`) only point at it.
- Run `dart run scripts/validate_skills.dart` after editing any skill and fix every error.
- Run `dart run scripts/check_versions.dart` after changing a version; all versions must match.
- Skill text is ASCII only, tool-agnostic ("the agent"), and each `SKILL.md` stays under 500 lines.
