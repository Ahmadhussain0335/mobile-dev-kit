# Installing mobile-dev-kit

This guide covers every supported tool, project versus global installs, updating, removing and
troubleshooting. The short version is in the [README](../README.md).

## Project or global

- **Project install**: skills go into a folder inside the repository, such as `.claude/skills` or
  `.agents/skills`. Commit that folder to share the skills with your team; they apply only to that project.
- **Global install**: skills go into a folder in your home directory and apply to every project on your
  machine. Nothing is committed.

The CLIs (`mobile-dev-kit` on npm, `mobile_dev_kit` on pub.dev) do project installs by default and global
installs with `--global`. Plugin and extension installs (Claude Code, Codex, Copilot CLI, Gemini CLI) are
managed by the tool itself and are user-level.

## Skills folders per tool

| Tool | `--tool` | Project folder | Global folder |
|---|---|---|---|
| Claude Code | `claude` | `.claude/skills` | `~/.claude/skills` |
| OpenAI Codex | `codex` | `.agents/skills` | `~/.agents/skills` |
| Gemini CLI | `gemini` | `.agents/skills` | `~/.gemini/skills` |
| GitHub Copilot | `copilot` | `.github/skills` | `~/.copilot/skills` |
| Cursor | `cursor` | `.cursor/skills` | `~/.cursor/skills` |
| Google Antigravity | `antigravity` | `.agents/skills` | `~/.gemini/config/skills` |
| Windsurf (Devin Desktop) | `windsurf` | `.windsurf/skills` | `~/.codeium/windsurf/skills` |
| Any tool reading `.agents/skills` | `agents` | `.agents/skills` | `~/.agents/skills` |

`~` is `HOME`, or `USERPROFILE` on Windows. The sources for every path are in [SOURCES.md](SOURCES.md).

Many tools read more than one folder. Cursor and Copilot, for example, also read `.claude/skills` and
`.agents/skills`. Installing into all folders at once can make a skill appear twice; install for the tools
you use.

## Claude Code

As a plugin (recommended, updates through the marketplace):

```sh
claude plugin marketplace add Ahmadhussain0335/mobile-dev-kit
claude plugin install mobile-dev-kit@ahmadhussain-mobile
```

Inside a session the same works with `/plugin marketplace add Ahmadhussain0335/mobile-dev-kit` and
`/plugin install mobile-dev-kit@ahmadhussain-mobile`. Plugin skills are namespaced, for example
`/mobile-dev-kit:mobile-code-review`.

As plain skills instead:

```sh
npx mobile-dev-kit install --tool claude            # this project
npx mobile-dev-kit install --tool claude --global   # all projects
```

Update: `claude plugin marketplace update ahmadhussain-mobile`, then
`claude plugin update mobile-dev-kit@ahmadhussain-mobile`.
Remove: `claude plugin uninstall mobile-dev-kit@ahmadhussain-mobile`.

## Claude.ai and the Claude desktop app

1. Download the zips you want from the
   [latest release](https://github.com/Ahmadhussain0335/mobile-dev-kit/releases/latest). Each
   `<skill>.zip` contains one `<skill>/` folder with `SKILL.md` inside, which is the layout the upload expects.
2. Open **Customize > Skills**, upload each zip and turn the skill on.

`mobile-dev-kit-all-skills.zip` contains every skill for convenience. Unpack it; it is not a single upload.

## OpenAI Codex

```sh
codex plugin marketplace add Ahmadhussain0335/mobile-dev-kit
```

Then install **Mobile Dev Kit** from the plugin directory. Codex reads `.agents/plugins/marketplace.json`
from this repository.

Skills only, without the plugin:

```sh
npx mobile-dev-kit install --tool codex             # .agents/skills in this repository
npx mobile-dev-kit install --tool codex --global    # ~/.agents/skills
```

## ChatGPT

Upload the `<skill>.zip` files from the
[latest release](https://github.com/Ahmadhussain0335/mobile-dev-kit/releases/latest) as skills, one zip per
skill. The ChatGPT desktop app can also read the Codex marketplace of this repository.

## Gemini CLI

```sh
gemini extensions install https://github.com/Ahmadhussain0335/mobile-dev-kit
```

The extension loads the skills from `skills/` and the short context file `GEMINI.md`.
Update: `gemini extensions update mobile-dev-kit`. Remove: `gemini extensions uninstall mobile-dev-kit`.

Skills only: `npx mobile-dev-kit install --tool gemini` (`.agents/skills`), or `--global` (`~/.gemini/skills`).

## Google Antigravity

```sh
npx mobile-dev-kit install --tool antigravity            # <workspace>/.agents/skills
npx mobile-dev-kit install --tool antigravity --global   # ~/.gemini/config/skills
```

## GitHub Copilot

Copilot CLI, as a plugin:

```sh
copilot plugin install Ahmadhussain0335/mobile-dev-kit
```

Or through the marketplace: `copilot plugin marketplace add Ahmadhussain0335/mobile-dev-kit`, then
`copilot plugin install mobile-dev-kit@ahmadhussain-mobile`.

Copilot in the editor and the Copilot cloud agent read project skills from `.github/skills`:

```sh
npx mobile-dev-kit install --tool copilot             # .github/skills
npx mobile-dev-kit install --tool copilot --global    # ~/.copilot/skills
```

## Cursor

This repository is a single Cursor plugin: `.cursor-plugin/plugin.json` sits at the root next to `skills/`,
which is the layout Cursor's plugin template uses for one plugin per repository.

Local plugin, from GitHub:

```sh
git clone https://github.com/Ahmadhussain0335/mobile-dev-kit ~/.cursor/plugins/local/mobile-dev-kit
```

Then restart Cursor or run **Developer: Reload Window**. Update later with
`git -C ~/.cursor/plugins/local/mobile-dev-kit pull`.

Team marketplace: an admin adds this repository under **Dashboard > Plugins & MCPs > Add Marketplace >
Import from Repo**; developers then install it from **Customize**.

Cursor marketplace, once listed: **Customize**, find **Mobile Dev Kit**, **Install**.

Skills only:

```sh
npx mobile-dev-kit install --tool cursor             # .cursor/skills
npx mobile-dev-kit install --tool cursor --global    # ~/.cursor/skills
```

## Windsurf (Devin Desktop)

```sh
npx mobile-dev-kit install --tool windsurf             # .windsurf/skills
npx mobile-dev-kit install --tool windsurf --global    # ~/.codeium/windsurf/skills
```

Newer versions prefer `.devin/skills` but still read `.windsurf/skills` and `.agents/skills`.

## Universal: npx skills

The [`skills`](https://www.npmjs.com/package/skills) CLI reads this repository directly:

```sh
npx skills add Ahmadhussain0335/mobile-dev-kit              # pick agents interactively
npx skills add Ahmadhussain0335/mobile-dev-kit --list       # list skills only
npx skills add Ahmadhussain0335/mobile-dev-kit -s mobile-security -a cursor
```

## Plugin-only features

Slash commands (`commands/`) and read-only subagents (`agents/`) come only with plugin and extension
installs: Claude Code, Gemini CLI (commands), Cursor and Copilot CLI (agents). The CLIs, zips and
`npx skills add` install the skills only. See the README for the command list.

## mobile-dev-kit CLIs

Two CLIs with the same commands, flags and behaviour. Use whichever runtime you have.

| | npm | pub.dev |
|---|---|---|
| Run once | `npx mobile-dev-kit <command>` | n/a |
| Install | `npm install -g mobile-dev-kit` | `dart install mobile_dev_kit` (Dart 3.10+) or `dart pub global activate mobile_dev_kit` |
| Command | `mobile-dev-kit` | `mobile_dev_kit` |
| Requires | Node.js 18+ | Dart 3.5+ |

Commands:

```sh
mobile-dev-kit list                       # bundled skills
mobile-dev-kit targets                    # tools and folders
mobile-dev-kit install [options]          # copy skills
mobile-dev-kit uninstall [options]        # remove what this CLI installed
mobile-dev-kit doctor                     # what is installed where, and if it is outdated
mobile-dev-kit --version
```

Options for `install` and `uninstall`:

| Option | Meaning |
|---|---|
| `-t, --tool <tool>` | Tool name from the table above, or `all`. Repeatable. Default: `claude` and `agents` |
| `-s, --skill <name>` | Skill name. Repeatable. Default: all |
| `-g, --global` | Use the global folders |
| `-n, --dry-run` | Print the plan, write nothing |
| `-d, --dir <path>` | Project root (default: current directory). With `--global`, used as the home directory |
| `-f, --force` | `install` only: overwrite skill folders the CLI did not create |

How the CLIs keep your files safe:

- Every installed skill folder gets a `.mobile-dev-kit.json` marker listing the files written. Both CLIs use
  the same marker, so either can update or remove the other's installs.
- `install` skips a folder that exists without the marker (exit code 1) unless `--force`. With `--force`
  it writes the bundled files and keeps any other files in the folder.
- Symbolic links are never followed or replaced.
- `uninstall` removes only folders with the marker and only the files the marker lists; folders with other
  files are kept.

Update: run the same `install` command with the newer CLI. `doctor` shows outdated folders.

## Troubleshooting

| Problem | Fix |
|---|---|
| Skills do not show up | Restart the tool or start a new session; most tools read skills at startup. Check the folder with `mobile-dev-kit doctor`. |
| A skill appears twice | The tool reads several folders. Uninstall from the folders you do not need, for example `mobile-dev-kit uninstall --tool agents`. |
| `skipped (exists)` on install | A folder with that skill name exists and was not created by the CLI. Inspect it, then use `--force` to overwrite. |
| `skipped (link/file)` | The skill path is a symbolic link or a file. Remove it yourself if the CLI should manage it. |
| `mobile_dev_kit: command not found` | Add the directory printed by `dart install` (or `dart pub global activate`) to `PATH`. |
| `Bad CPU type in executable: node` (macOS) | The Node.js build does not match the Mac's CPU. Install the matching build, for example with nvm: `nvm install 22 && nvm alias default 22`. |
| Claude Code refuses the marketplace name | Another marketplace is registered as `ahmadhussain-mobile`. Remove it with `claude plugin marketplace remove ahmadhussain-mobile` and add again. |
| Codex or Cursor does not list the plugin | Restart the app after adding the marketplace; both read marketplaces at startup. |

## Maintainer: releasing

One version number covers everything. To release `X.Y.Z`:

1. Update the version in every place `dart run scripts/check_versions.dart` lists, and add a `## X.Y.Z`
   section to `CHANGELOG.md` and `packages/dart/CHANGELOG.md`.
2. In `packages/dart`, run `dart run tool/embed_skills.dart` if any skill changed.
3. Commit, merge to `main`, then tag and push: `git tag vX.Y.Z && git push origin vX.Y.Z`.
4. `.github/workflows/release.yml` verifies the tag, builds the zips, creates the GitHub Release and
   publishes to pub.dev and npm through OIDC trusted publishing.

One-time setup before the first automated release:

- **First publish is manual on both registries**: trusted publishing is configured on an existing package.
  Publish 1.0.0 once by hand (`dart pub publish` in `packages/dart`, `npm publish --access public` in
  `packages/npm`).
- **pub.dev**: package **Admin** tab, **Automated publishing**: enable GitHub Actions, repository
  `Ahmadhussain0335/mobile-dev-kit`, tag pattern `v{{version}}`, and require the environment `pub.dev`.
- **npmjs.com**: package **Settings > Trusted Publisher > GitHub Actions**: user `Ahmadhussain0335`,
  repository `mobile-dev-kit`, workflow `release.yml`, environment `npm`. A new configuration must be used
  for a successful publish within 2 days or it expires.
- **GitHub**: create the environments `pub.dev` and `npm` under **Settings > Environments**, add yourself as
  a required reviewer, and protect `v*` tags under **Settings > Rules**.
