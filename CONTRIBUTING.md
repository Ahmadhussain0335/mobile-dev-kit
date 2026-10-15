# Contributing

Thanks for helping. This project follows the [Code of Conduct](CODE_OF_CONDUCT.md). Skills are the product here, so most contributions are a new skill or a better rule in
an existing one.

## Ground rules

- `skills/` is the single source of truth. Never edit the copies in `packages/dart/lib/src/skills_data.g.dart`
  or `packages/npm/skills/`; they are generated.
- Skill text is ASCII only: no emojis, smart quotes or em dashes (use `--`).
- Tool-agnostic wording: write "the agent", never the name of an AI product.
- Current, real APIs only. If you are not sure an API, flag or setting exists, leave it out.
- Short points with examples. No dense paragraphs.
- Conventional Commits (`feat:`, `fix:`, `docs:`, `chore:`), one topic per commit and per pull request.

## Setup

You need the Dart SDK (3.5 or newer) for the scripts and the Dart CLI, and Node.js 18 or newer for the npm CLI.

```sh
dart pub get --directory scripts
```

## Add a skill

1. Create `skills/<name>/SKILL.md`. The folder name and `name` must match and be kebab-case. Prefix
   general topics with `mobile-` so they do not clash with other skill packs.
2. Start from the template below. Keep `SKILL.md` under 500 lines; move long examples to
   `references/<topic>.md` and link every reference file from `SKILL.md`.
3. Run the validator and fix every error:

   ```sh
   dart run scripts/validate_skills.dart
   ```

4. Regenerate the Dart CLI's embedded copy and run its tests:

   ```sh
   cd packages/dart
   dart run tool/embed_skills.dart
   dart test
   ```

5. Add the skill to the tables in `README.md`, `AGENTS.md` and `GEMINI.md`, and note it in `CHANGELOG.md`
   under an `## Unreleased` heading.

### Template

````markdown
---
name: mobile-example
description: "Does X for Android, iOS and Flutter apps in Kotlin, Java, Swift and Dart. Covers <key terms
  and APIs people will type>. Use when <the situations and phrases that should trigger it>."
license: MIT
metadata:
  author: Your Name
  version: "1.0.0"
  pack: mobile-dev-kit
---

# Example

One or two sentences: what the agent does with this skill and what a good result looks like.

## When to use

- Trigger situations.

Not for: neighbouring topics, with the skill to use instead.

## Workflow

1. Numbered steps the agent follows. Point to `references/` files at the step that needs them.

## Rules

### 1. Short rule title

```kotlin
// BAD
...

// GOOD
...
```

(Swift, Java and Dart variants where they differ.)

## Anti-patterns

- Common mistakes.

## Checklist

- [ ] Verifiable items.

## Output format

(Only for review, audit and MR skills.)

## Related skills

- `mobile-code-review` -- why it is related
````

The description is what tools read to decide whether to load the skill: third person, what it does and
when to use it, with the words a user would type, at most 1024 characters. Quote it if it contains `: `.

## What the validator checks

`scripts/validate_skills.dart` fails on:

- missing or invalid YAML frontmatter, unknown frontmatter keys
- `name` not kebab-case or not equal to the folder name
- missing or over-long description; `license` other than MIT; missing `metadata.author`, `metadata.version`
  or `metadata.pack`
- any non-ASCII character in any skill file
- `SKILL.md` with 500 lines or more
- missing required sections (`When to use`, `Workflow`, `Rules`, `Anti-patterns`, `Checklist`,
  `Related skills`)
- AI product names outside code spans
- broken relative links, and reference files that `SKILL.md` never links

## Evals

Evals show that a skill changes what the agent does. They use the `claude plugin eval` format.

- **Every new skill needs at least two evals.** The validator prints which skills have fewer.
- A case is a folder under `evals/<case>/`:
  - `prompt.md` -- a request phrased the way a user would type it (do not name the skill), with
    `max_turns`, `timeout_seconds` and `allowed_tools: [Read, Glob, Grep, Skill]` in the frontmatter.
  - `case.yaml` -- `schema_version: "1.1"`, `name`, and `context.add_dirs: [fixture]`.
  - `fixture/` -- small, deliberately flawed code plus at least one correct "decoy" the agent must not flag.
  - `graders/` -- one `regex` grader per must-find issue (free and stable), an `llm` grader for findings a regex
    cannot capture, `no-false-positives.md` (an `llm` grader naming the decoys), and `skill-fired.md`
    (`type: tool_used`, `tool: Skill`, `input_match` with the skill name).
- Fake secrets in fixtures must not look like real keys: use values such as `fake-demo-value-not-a-real-secret`.
- Run locally (uses your own credentials and costs money):

  ```sh
  claude plugin eval . --case kotlin-review --runs 1 --ablation none --max-cost-usd 2
  ```

- In GitHub, run the **Evals** workflow manually (Actions > Evals > Run workflow). It needs the repository secret
  `ANTHROPIC_API_KEY` and never runs on push or pull request.
- Results go to `evals/results/`, which is git-ignored.

## Change agents or commands

- Agents live in `agents/<name>.agent.md` (the `.agent.md` suffix is what Copilot CLI reads; Claude Code and
  Cursor read it too). `name` must equal the file name, and `tools` must be listed explicitly; keep agents
  read-only.
- Each command is `commands/<name>.md` (Claude Code, Cursor) plus `commands/mobile-dev-kit/<name>.toml`
  (Gemini CLI, which makes it `/mobile-dev-kit:<name>`). The validator fails if one of the pair is missing.
- Pre-approve (`allowed-tools`) only the exact commands a command injects, never wildcards such as
  `Bash(git branch *)`, which would also match destructive subcommands.

## Change the CLIs

- Dart: `packages/dart`. Run `dart format .`, `dart analyze --fatal-infos` and `dart test`.
- npm: `packages/npm`, no runtime dependencies. Run `npm test`.
- The tool-to-folder table exists once per CLI (`packages/dart/lib/src/targets.dart`,
  `packages/npm/lib/targets.js`); a test fails if they differ. Cite the source for any path change in
  `docs/SOURCES.md`.

## Versions and releases

One version covers the skills, all manifests and both CLIs. `dart run scripts/check_versions.dart` fails if
any differ. The release steps are in [docs/INSTALL.md](docs/INSTALL.md#maintainer-releasing).

## Reporting security issues

Do not open a public issue for a vulnerability in the CLIs or the manifests. Use GitHub's private
vulnerability reporting on this repository (**Security > Report a vulnerability**).
