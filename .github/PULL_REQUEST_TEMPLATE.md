## Summary

<!-- What changes and why. Link the issue if there is one. -->

## Checklist

- [ ] `dart run scripts/validate_skills.dart` passes (no errors)
- [ ] `dart run scripts/check_versions.dart` passes (versions in sync)
- [ ] New or changed skills: at least two evals added or updated under `evals/`
- [ ] Skill text is ASCII only, tool-agnostic ("the agent") and SKILL.md is under 500 lines
- [ ] Version-specific facts link to an official source, added to `docs/SOURCES.md`
- [ ] Skill changes: `dart run tool/embed_skills.dart` run in `packages/dart`
- [ ] Agents or commands: `.md` and Gemini `.toml` stay in sync; `allowed-tools` lists exact commands only
- [ ] `CHANGELOG.md` updated
- [ ] Commits follow Conventional Commits
