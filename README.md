# mobile-dev-kit

[![CI](https://github.com/Ahmadhussain0335/mobile-dev-kit/actions/workflows/ci.yml/badge.svg)](https://github.com/Ahmadhussain0335/mobile-dev-kit/actions/workflows/ci.yml)
[![pub package](https://img.shields.io/pub/v/mobile_dev_kit.svg)](https://pub.dev/packages/mobile_dev_kit)
[![npm](https://img.shields.io/npm/v/mobile-dev-kit.svg)](https://www.npmjs.com/package/mobile-dev-kit)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

**The EU-ready, cross-platform mobile kit: one review, security, compliance and release standard for
Android, iOS and Flutter teams.**

Agent Skills packaged once and installable in every major AI coding tool: Claude Code, Claude.ai, OpenAI Codex,
ChatGPT, Gemini CLI, Google Antigravity, GitHub Copilot, Cursor and Windsurf. Each skill is a plain `SKILL.md`
file in the open [Agent Skills](https://agentskills.io) format, with a workflow, rules with bad and good examples
in Kotlin, Java, Swift and Dart, a checklist and an output format. The skill content is identical in every tool;
only thin manifests differ.

**Release status:** pre-release. Installing from GitHub works now; the release zips, `npx mobile-dev-kit` and
`dart install mobile_dev_kit` are available from v1.0.0.

## Why this kit

- **One standard across three platforms.** The same severity levels, review checklist and report formats for
  Kotlin, Java, Swift and Dart, so Android, iOS and Flutter reviews read alike.
- **EU-ready.** Gap reports against the Cyber Resilience Act, the RED delegated act with EN 18031, GDPR and the
  European Accessibility Act, with dates and requirements checked against the Official Journal. Engineering
  guidance, not legal advice.
- **Connected devices.** Bluetooth Low Energy, firmware update safety and companion-app compliance, which general
  mobile packs rarely cover.
- **From review to release.** Code review, security audit, CI/CD, merge requests, store readiness, testing and
  performance, plus read-only agents and slash commands for the common checks.
- **Checked, not guessed.** Every version-specific fact links to an official source in
  [docs/SOURCES.md](docs/SOURCES.md), a validator enforces the format, and [evals](evals/) test the skills
  against deliberately flawed code.

## How this differs from other packs

This kit is complementary to the official and community packs; install them alongside it.

| Pack | Focus | Use it for |
|---|---|---|
| [Android skills](https://developer.android.com/tools/agents/android-skills) (`android/skills`, by Google) | Specific Android workflows: XML to Compose migration, AGP 9 upgrades, Navigation 3, edge-to-edge, R8 audits | Android migrations and platform features, installed with the Android CLI |
| [Flutter and Dart skills](https://docs.flutter.dev/ai/agent-skills) (`flutter/agent-plugins` and `dart-lang/skills`, `dart-flutter` plugin) | Flutter and Dart development tasks, rules, the Dart and Flutter MCP server and an accessibility agent | Day-to-day Flutter and Dart work with live analyzer and runtime access |
| Large iOS packs, for example [twostraws/swiftui-agent-skill](https://github.com/twostraws/swiftui-agent-skill) and [dpearson2699/swift-ios-skills](https://github.com/dpearson2699/swift-ios-skills) | Depth on Swift, SwiftUI and Apple frameworks | Detailed Apple-platform APIs |
| mobile-dev-kit | A shared review, security, EU compliance, BLE and release standard across Android, iOS and Flutter | Cross-platform teams, connected devices and EU-market products |

Skill names here all start with `mobile-`, so they do not clash with these packs.

## Example

A short, deliberately flawed Kotlin file from the `kotlin-review` eval
([evals/kotlin-review/fixture](evals/kotlin-review/fixture)):

```kotlin
class DeviceViewModel(private val repository: DeviceRepository) : ViewModel() {
    private val _state = MutableStateFlow(DeviceUiState())
    val state: StateFlow<DeviceUiState> = _state.asStateFlow()

    fun refresh() {
        GlobalScope.launch {
            val devices = repository.loadDevices()
            _state.update { it.copy(devices = devices, loading = false) }
        }
    }
}

object ConnectionTracker {
    lateinit var context: Context   // set from MainActivity.onCreate
}
```

Asked "review this before I merge it", the `mobile-code-review` skill must report the `GlobalScope` launch,
the lifecycle-unaware `collectAsState()` in the screen and the Activity leak in `ConnectionTracker`, with
severity, file:line and a fix, and must not flag the correct code beside them.

The review output from an actual eval run will be added here after the first run of
`claude plugin eval . --case kotlin-review`; it is not reproduced from memory.

## Skills

| Skill | What it does |
|---|---|
| [`mobile-code-review`](skills/mobile-code-review/SKILL.md) | Reviews Kotlin, Java, Swift and Dart diffs for correctness, concurrency, leaks, UI performance, architecture, tests, accessibility and i18n, with Blocker/Major/Minor/Nit findings and a verdict |
| [`mobile-security`](skills/mobile-security/SKILL.md) | Audits against OWASP MASVS v2 and Mobile Top 10 2024: storage, crypto, auth, network, IPC, WebViews, privacy, plus GDPR, Cyber Resilience Act and EN 18031 notes |
| [`mobile-accessibility`](skills/mobile-accessibility/SKILL.md) | Audits Android, iOS and Flutter apps against WCAG 2.2 AA and EN 301 549 and checks whether the European Accessibility Act applies, with automated checks and a screen-reader test script |
| [`mobile-eu-compliance`](skills/mobile-eu-compliance/SKILL.md) | Gap reports against the EU Cyber Resilience Act, the RED delegated act with EN 18031 and GDPR for apps and connected-device companion apps; engineering guidance, not legal advice |
| [`mobile-ci-cd`](skills/mobile-ci-cd/SKILL.md) | GitHub Actions and GitLab CI for Android, iOS and Flutter: signing, store upload, caching, SHA-pinned actions, secret hygiene |
| [`mobile-release`](skills/mobile-release/SKILL.md) | Store readiness for Google Play and the App Store: target API level, Data safety, privacy manifests, account deletion, signing, staged and phased rollout, rollback |
| [`mobile-testing`](skills/mobile-testing/SKILL.md) | Cross-platform test strategy: test pyramid, fakes over mocks, Compose UI tests, XCUITest, integration_test, screenshot tests, flaky-test rules, CI sharding |
| [`mobile-performance`](skills/mobile-performance/SKILL.md) | Measure-first performance work: startup, jank, memory leaks, app size, battery and network, with Macrobenchmark, Perfetto, Instruments, DevTools, MetricKit and Android vitals |
| [`mobile-merge-request`](skills/mobile-merge-request/SKILL.md) | Branch naming, Conventional Commits, MR descriptions, stacked MRs, rebasing, conflict resolution, review etiquette |
| [`mobile-mvvm`](skills/mobile-mvvm/SKILL.md) | MVVM with Compose and StateFlow, LiveData, SwiftUI with `@Observable`, Riverpod; when to pick MVVM, MVI or MVC |
| [`mobile-mvi`](skills/mobile-mvi/SKILL.md) | MVI with intents, pure reducers, side effects, Bloc and Swift stores, with reducer tests |
| [`mobile-mvc`](skills/mobile-mvc/SKILL.md) | UIKit MVC without Massive View Controller, Android MVP, Flutter controllers, step-by-step migration to MVVM |
| [`mobile-design-patterns`](skills/mobile-design-patterns/SKILL.md) | Repository, Strategy, State machine, Command, Coordinator, Result types and more, with when not to use them |
| [`mobile-ble`](skills/mobile-ble/SKILL.md) | Bluetooth Low Energy on Android, iOS and Flutter: permissions, GATT operation queues, MTU, bonding, reconnects, background limits, framing and CRC, safe firmware updates |
| [`mobile-kotlin`](skills/mobile-kotlin/SKILL.md) | Kotlin 2.x, coroutines, Flow, Jetpack Compose, Hilt, Room, Gradle version catalogs, tests |
| [`mobile-java`](skills/mobile-java/SKILL.md) | Java 17/21 on Android, leak-free threading, LiveData, Kotlin interop and incremental migration |
| [`mobile-swift`](skills/mobile-swift/SKILL.md) | Swift 6 strict concurrency, SwiftUI, SwiftData, SPM modules, Swift Testing |
| [`mobile-flutter`](skills/mobile-flutter/SKILL.md) | Dart 3, Flutter widgets and performance, Riverpod or Bloc, go_router, Pigeon, tests |
| [`mobile-kmp`](skills/mobile-kmp/SKILL.md) | Kotlin Multiplatform and Compose Multiplatform: source sets, interfaces over expect/actual, shared ViewModels, Ktor, Room or SQLDelight, coroutines on iOS, XCFramework and SPM |

## Install

Pick your tool. [docs/INSTALL.md](docs/INSTALL.md) has the detailed version, global versus project installs,
updating and troubleshooting.

### Claude Code

```sh
claude plugin marketplace add Ahmadhussain0335/mobile-dev-kit
claude plugin install mobile-dev-kit@ahmadhussain-mobile
```

### Claude.ai

Available from v1.0.0.

Download the `<skill>.zip` files you want from the
[latest release](https://github.com/Ahmadhussain0335/mobile-dev-kit/releases/latest), then upload each one
under **Customize > Skills** and turn it on.

### OpenAI Codex

```sh
codex plugin marketplace add Ahmadhussain0335/mobile-dev-kit
```

Then install **Mobile Dev Kit** from the plugin directory. To copy the skills only (available from v1.0.0):
`npx mobile-dev-kit install --tool codex`.

### ChatGPT

Available from v1.0.0.

Download the `<skill>.zip` files from the
[latest release](https://github.com/Ahmadhussain0335/mobile-dev-kit/releases/latest) and upload them as
skills. Each zip holds one skill.

### Gemini CLI

```sh
gemini extensions install https://github.com/Ahmadhussain0335/mobile-dev-kit
```

### Google Antigravity

Available from v1.0.0.

```sh
npx mobile-dev-kit install --tool antigravity            # this workspace
npx mobile-dev-kit install --tool antigravity --global   # every workspace
```

### GitHub Copilot

Copilot CLI:

```sh
copilot plugin install Ahmadhussain0335/mobile-dev-kit
```

Copilot in the editor and the cloud agent read `.github/skills` (available from v1.0.0):
`npx mobile-dev-kit install --tool copilot`.

### Cursor

From GitHub, as a local plugin:

```sh
git clone https://github.com/Ahmadhussain0335/mobile-dev-kit ~/.cursor/plugins/local/mobile-dev-kit
```

Then run **Developer: Reload Window**. Teams: an admin adds this repository under
**Dashboard > Plugins & MCPs > Add Marketplace > Import from Repo**. Skills only (available from v1.0.0):
`npx mobile-dev-kit install --tool cursor`.

### Windsurf

Available from v1.0.0.

```sh
npx mobile-dev-kit install --tool windsurf
```

### Any tool (universal)

```sh
npx skills add Ahmadhussain0335/mobile-dev-kit
```

### Dart CLI (pub.dev)

Available from v1.0.0.

```sh
dart install mobile_dev_kit      # Dart 3.10+; older SDKs: dart pub global activate mobile_dev_kit
mobile_dev_kit install
```

### npm CLI

Available from v1.0.0.

```sh
npx mobile-dev-kit install       # or: npm install -g mobile-dev-kit
```

Both CLIs install into `.claude/skills` and `.agents/skills` by default, which covers Claude Code, Codex,
Gemini CLI, Cursor, Copilot and Antigravity. Run `mobile-dev-kit targets` for every tool and folder.

## Commands and agents

Plugin installs (Claude Code, Gemini CLI, Cursor, Copilot CLI) also add slash commands and read-only
subagents. The `mobile-dev-kit` / `mobile_dev_kit` CLIs, zips and `npx skills` install skills only.

| Command | What it does |
|---|---|
| `/mobile-dev-kit:review [base-branch]` | Reviews the current branch against its merge base with `mobile-code-review` |
| `/mobile-dev-kit:audit [path]` | Security and EU compliance audit; writes `reports/security-audit-<date>.md` |
| `/mobile-dev-kit:mr [base-branch]` | Writes the MR or PR description for the current branch |
| `/mobile-dev-kit:release-check [android\|ios\|all]` | Google Play and App Store readiness checklist |
| `/mobile-dev-kit:a11y <screen or module>` | Accessibility audit against WCAG 2.2 AA |

| Agent | Skills it applies | Tools |
|---|---|---|
| `mobile-reviewer` | `mobile-code-review` | Read, Grep, Glob |
| `mobile-security-auditor` | `mobile-security`, `mobile-eu-compliance` | Read, Grep, Glob |
| `mobile-release-checker` | `mobile-release` | Read, Grep, Glob |

The agents never run commands or edit files. The commands gather git information first; only
`git branch --show-current`, `git status --short` and `date +%F` are pre-approved, every other command asks
for permission as usual.

| | Claude Code | Gemini CLI | Cursor | Copilot CLI | Codex |
|---|---|---|---|---|---|
| Commands | `/mobile-dev-kit:<name>` | `/mobile-dev-kit:<name>` (TOML) | from `commands/` | not documented for plugins | no |
| Agents | yes | no | from `agents/` | yes (`.agent.md`) | no |

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
- "Is our BLE companion app ready for the CRA and EN 18031?"
- "Why do our GATT writes sometimes get lost on Android?"
- "Audit this checkout screen against WCAG 2.2 AA."
- "Are we ready to submit to Google Play and the App Store?"
- "Our app starts slowly. Measure it and tell us what to fix first."

## Repository layout

```
skills/                  the skills (single source of truth)
.claude-plugin/          Claude Code plugin and marketplace
.codex-plugin/           Codex plugin manifest
.cursor-plugin/          Cursor plugin manifest
.agents/plugins/         Codex marketplace
agents/                  read-only subagents (Claude Code, Copilot CLI, Cursor)
commands/                slash commands: *.md (Claude Code, Cursor), mobile-dev-kit/*.toml (Gemini CLI)
gemini-extension.json    Gemini CLI extension, with GEMINI.md
AGENTS.md                skill index for tools that read AGENTS.md
packages/dart/           mobile_dev_kit on pub.dev
packages/npm/            mobile-dev-kit on npm
scripts/                 validator, version check, zip builder
evals/                   claude plugin eval cases with flawed fixtures and graders
docs/                    install guide and the documentation sources used
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Every change runs through `dart run scripts/validate_skills.dart`.

## License

MIT. See [LICENSE](LICENSE).
