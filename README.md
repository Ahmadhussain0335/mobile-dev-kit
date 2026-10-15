# mobile-dev-kit

Twelve Agent Skills for Android, iOS and Flutter developers, packaged once and installable in every major AI
coding tool: Claude Code, Claude.ai, OpenAI Codex, ChatGPT, Gemini CLI, Google Antigravity, GitHub Copilot,
Cursor and Windsurf.

Each skill is a plain `SKILL.md` file in the open [Agent Skills](https://agentskills.io) format, with a
workflow, rules with bad and good examples in Kotlin, Java, Swift and Dart, a checklist and, where it
matters, an output format. The skill content is identical in every tool; only thin manifests differ.

## Skills

| Skill | What it does |
|---|---|
| [`mobile-code-review`](skills/mobile-code-review/SKILL.md) | Reviews Kotlin, Java, Swift and Dart diffs for correctness, concurrency, leaks, UI performance, architecture, tests, accessibility and i18n, with Blocker/Major/Minor/Nit findings and a verdict |
| [`mobile-security`](skills/mobile-security/SKILL.md) | Audits against OWASP MASVS v2 and Mobile Top 10 2024: storage, crypto, auth, network, IPC, WebViews, privacy, plus GDPR, Cyber Resilience Act and EN 18031 notes |
| [`mobile-ci-cd`](skills/mobile-ci-cd/SKILL.md) | GitHub Actions and GitLab CI for Android, iOS and Flutter: signing, store upload, caching, SHA-pinned actions, secret hygiene |
| [`mobile-merge-request`](skills/mobile-merge-request/SKILL.md) | Branch naming, Conventional Commits, MR descriptions, stacked MRs, rebasing, conflict resolution, review etiquette |
| [`mobile-mvvm`](skills/mobile-mvvm/SKILL.md) | MVVM with Compose and StateFlow, LiveData, SwiftUI with `@Observable`, Riverpod; when to pick MVVM, MVI or MVC |
| [`mobile-mvi`](skills/mobile-mvi/SKILL.md) | MVI with intents, pure reducers, side effects, Bloc and Swift stores, with reducer tests |
| [`mobile-mvc`](skills/mobile-mvc/SKILL.md) | UIKit MVC without Massive View Controller, Android MVP, Flutter controllers, step-by-step migration to MVVM |
| [`mobile-design-patterns`](skills/mobile-design-patterns/SKILL.md) | Repository, Strategy, State machine, Command, Coordinator, Result types and more, with when not to use them |
| [`kotlin-android`](skills/kotlin-android/SKILL.md) | Kotlin 2.x, coroutines, Flow, Jetpack Compose, Hilt, Room, Gradle version catalogs, tests |
| [`java-android`](skills/java-android/SKILL.md) | Java 17/21 on Android, leak-free threading, LiveData, Kotlin interop and incremental migration |
| [`swift-ios`](skills/swift-ios/SKILL.md) | Swift 6 strict concurrency, SwiftUI, SwiftData, SPM modules, Swift Testing |
| [`dart-flutter`](skills/dart-flutter/SKILL.md) | Dart 3, Flutter widgets and performance, Riverpod or Bloc, go_router, Pigeon, tests |

## Install

Pick your tool. [docs/INSTALL.md](docs/INSTALL.md) has the detailed version, global versus project installs,
updating and troubleshooting.

### Claude Code

```sh
claude plugin marketplace add Ahmadhussain0335/mobile-dev-kit
claude plugin install mobile-dev-kit@ahmadhussain-mobile
```

### Claude.ai

Download the `<skill>.zip` files you want from the
[latest release](https://github.com/Ahmadhussain0335/mobile-dev-kit/releases/latest), then upload each one
under **Customize > Skills** and turn it on.

### OpenAI Codex

```sh
codex plugin marketplace add Ahmadhussain0335/mobile-dev-kit
```

Then install **Mobile Dev Kit** from the plugin directory. To copy the skills only:
`npx mobile-dev-kit install --tool codex`.

### ChatGPT

Download the `<skill>.zip` files from the
[latest release](https://github.com/Ahmadhussain0335/mobile-dev-kit/releases/latest) and upload them as
skills. Each zip holds one skill.

### Gemini CLI

```sh
gemini extensions install https://github.com/Ahmadhussain0335/mobile-dev-kit
```

### Google Antigravity

```sh
npx mobile-dev-kit install --tool antigravity            # this workspace
npx mobile-dev-kit install --tool antigravity --global   # every workspace
```

### GitHub Copilot

Copilot CLI:

```sh
copilot plugin install Ahmadhussain0335/mobile-dev-kit
```

Copilot in the editor and the cloud agent read `.github/skills`:
`npx mobile-dev-kit install --tool copilot`.

### Cursor

Install **Mobile Dev Kit** from the Cursor marketplace once it is listed, or copy the skills:

```sh
npx mobile-dev-kit install --tool cursor
```

### Windsurf

```sh
npx mobile-dev-kit install --tool windsurf
```

### Any tool (universal)

```sh
npx skills add Ahmadhussain0335/mobile-dev-kit
```

### Dart CLI (pub.dev)

```sh
dart install mobile_dev_kit      # Dart 3.10+; older SDKs: dart pub global activate mobile_dev_kit
mobile_dev_kit install
```

### npm CLI

```sh
npx mobile-dev-kit install       # or: npm install -g mobile-dev-kit
```

Both CLIs install into `.claude/skills` and `.agents/skills` by default, which covers Claude Code, Codex,
Gemini CLI, Cursor, Copilot and Antigravity. Run `mobile-dev-kit targets` for every tool and folder.

## Usage

Once installed, ask in plain language; the agent picks the matching skill.

- "Review this merge request for bugs, leaks and threading issues."
- "Review this MR for security issues against MASVS."
- "Set up GitHub Actions for this Flutter app with signed release builds."
- "Write the MR description for my current branch."
- "Refactor this screen to MVI with a pure reducer and tests."
- "This view controller is 1,500 lines. Split it."
- "Convert this Java class to idiomatic Kotlin."
- "Make this SwiftUI view model safe under Swift 6 strict concurrency."

## Repository layout

```
skills/                  the skills (single source of truth)
.claude-plugin/          Claude Code plugin and marketplace
.codex-plugin/           Codex plugin manifest
.cursor-plugin/          Cursor plugin manifest
.agents/plugins/         Codex marketplace
plugin.json              Agent Plugins manifest (Codex, Copilot CLI, Cursor)
gemini-extension.json    Gemini CLI extension, with GEMINI.md
AGENTS.md                skill index for tools that read AGENTS.md
packages/dart/           mobile_dev_kit on pub.dev
packages/npm/            mobile-dev-kit on npm
scripts/                 validator, version check, zip builder
docs/                    install guide and the documentation sources used
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Every change runs through `dart run scripts/validate_skills.dart`.

## License

MIT. See [LICENSE](LICENSE).
