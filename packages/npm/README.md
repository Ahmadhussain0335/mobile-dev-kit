# mobile-dev-kit

Command-line installer for [mobile-dev-kit](https://github.com/Ahmadhussain0335/mobile-dev-kit): twelve
Agent Skills (`SKILL.md`) for Android, iOS and Flutter development, copied into the folders your AI coding
tools read.

The skills cover code review, OWASP MASVS security audits, CI/CD, merge requests, MVVM, MVI, MVC, design
patterns, Kotlin, Java, Swift and Dart. No runtime dependencies; Node.js 18 or newer.

## Usage

Run without installing:

```sh
npx mobile-dev-kit install
```

Or install globally:

```sh
npm install -g mobile-dev-kit
mobile-dev-kit install
```

The default installs every skill into the current project for Claude Code (`.claude/skills`) and the shared
`.agents/skills` folder (read by Codex, Gemini CLI, Cursor, GitHub Copilot and Antigravity).

```sh
mobile-dev-kit list                                    # bundled skills
mobile-dev-kit targets                                 # tools and their folders
mobile-dev-kit install --tool cursor --tool copilot    # specific tools
mobile-dev-kit install --tool all                      # every tool, shared folders written once
mobile-dev-kit install --global --tool claude          # user-level, all projects
mobile-dev-kit install --skill mobile-security         # one skill
mobile-dev-kit install --dry-run                       # show what would change
mobile-dev-kit uninstall --tool claude                 # remove what this tool installed
mobile-dev-kit doctor                                  # what is installed where, and if outdated
```

| Option | Meaning |
|---|---|
| `-t, --tool` | `claude`, `codex`, `gemini`, `copilot`, `cursor`, `antigravity`, `windsurf`, `agents` or `all`. Repeatable. Default: `claude` and `agents` |
| `-s, --skill` | Skill name. Repeatable. Default: all skills |
| `-g, --global` | Use the user-level folders in your home directory |
| `-f, --force` | `install` only: overwrite skill folders that this tool did not create |
| `-n, --dry-run` | Print the plan, write nothing |
| `-d, --dir` | Project root (default: current directory) |

Run `mobile-dev-kit targets` for the folder each tool uses.

## Safety

- Each installed skill folder gets a `.mobile-dev-kit.json` marker listing the files it wrote. The Dart CLI
  (`mobile_dev_kit` on pub.dev) uses the same marker, so either tool can update or remove the other's installs.
- `install` never overwrites a folder without that marker unless you pass `--force`, and never follows or
  replaces symbolic links.
- `uninstall` removes only folders with the marker, and only the files the marker lists.
- Nothing outside `<skills folder>/<skill name>/` is written or deleted.

Exit codes: `0` success, `1` some skills skipped or an error, `64` invalid arguments.

## License

MIT. See [LICENSE](LICENSE).
