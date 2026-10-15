# Contributing

Thanks for helping. Skills are the product here, so most contributions are a new skill or a better rule in
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
