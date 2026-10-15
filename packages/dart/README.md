# mobile_dev_kit

The EU-ready, cross-platform mobile kit: one review, security, compliance and release standard for Android,
iOS and Flutter teams.

Command-line installer for [mobile-dev-kit](https://github.com/Ahmadhussain0335/mobile-dev-kit):
Agent Skills (`SKILL.md`) copied into the folders your AI coding tools read.

The skills cover code review, OWASP MASVS security audits, EU compliance (Cyber Resilience Act, EN 18031,
GDPR), accessibility (WCAG 2.2, European Accessibility Act), Bluetooth Low Energy, Kotlin Multiplatform, CI/CD,
merge requests, store release readiness, testing, performance, MVVM, MVI, MVC, design patterns, and Kotlin, Java,
Swift and Dart. They are embedded in the executable, so the tool works offline.

This CLI installs the skills only. The plugin's slash commands and read-only agents come with plugin installs
(Claude Code, Gemini CLI, Cursor, Copilot CLI); see the
[install guide](https://github.com/Ahmadhussain0335/mobile-dev-kit/blob/main/docs/INSTALL.md).

## Install

Dart 3.10 or newer:

```sh
dart install mobile_dev_kit
```

Older Dart SDKs:

```sh
dart pub global activate mobile_dev_kit
```

Make sure the install directory printed by the command is on your `PATH`.

## Usage

Install every skill into the current project for Claude Code and the shared `.agents/skills` folder
(read by Codex, Gemini CLI, Cursor, GitHub Copilot and Antigravity):

```sh
mobile_dev_kit install
```

Other examples:

```sh
mobile_dev_kit list                                    # bundled skills
mobile_dev_kit targets                                 # tools and their folders
mobile_dev_kit install --tool cursor --tool copilot    # specific tools
mobile_dev_kit install --tool all                      # every tool, shared folders written once
mobile_dev_kit install --global --tool claude          # user-level, all projects
mobile_dev_kit install --skill mobile-security         # one skill
mobile_dev_kit install --dry-run                       # show what would change
mobile_dev_kit uninstall --tool claude                 # remove what this tool installed
mobile_dev_kit doctor                                  # what is installed where, and if outdated
```

| Option | Meaning |
|---|---|
| `-t, --tool` | `claude`, `codex`, `gemini`, `copilot`, `cursor`, `antigravity`, `windsurf`, `agents` or `all`. Repeatable. Default: `claude` and `agents` |
| `-s, --skill` | Skill name. Repeatable. Default: all skills |
| `-g, --global` | Use the user-level folders in your home directory |
| `-f, --force` | `install` only: overwrite skill folders that this tool did not create |
| `-n, --dry-run` | Print the plan, write nothing |
| `-d, --dir` | Project root (default: current directory) |

## Where skills go

| Tool | Project | Global |
|---|---|---|
| `claude` | `.claude/skills` | `~/.claude/skills` |
| `codex` | `.agents/skills` | `~/.agents/skills` |
| `gemini` | `.agents/skills` | `~/.gemini/skills` |
| `copilot` | `.github/skills` | `~/.copilot/skills` |
| `cursor` | `.cursor/skills` | `~/.cursor/skills` |
| `antigravity` | `.agents/skills` | `~/.gemini/config/skills` |
| `windsurf` | `.windsurf/skills` | `~/.codeium/windsurf/skills` |
| `agents` | `.agents/skills` | `~/.agents/skills` |

Some tools read several of these folders. Installing for many tools at once can make the same skill appear
twice in such a tool; install only for the tools you use.

## Safety

- Each installed skill folder gets a `.mobile-dev-kit.json` marker listing the files it wrote.
- `install` never overwrites a folder without that marker unless you pass `--force`, and never follows or
  replaces symbolic links.
- `uninstall` removes only folders with the marker, and only the files the marker lists. Files you added
  are kept.
- Nothing outside `<skills folder>/<skill name>/` is written or deleted.

## Exit codes

| Code | Meaning |
|---|---|
| 0 | Success |
| 1 | Some skills were skipped (existing folders, links) or an error occurred |
| 64 | Invalid arguments |

## Library use

The same operations are available from Dart; see [`example/mobile_dev_kit_example.dart`](example/mobile_dev_kit_example.dart).

## License

MIT. See [LICENSE](LICENSE).
