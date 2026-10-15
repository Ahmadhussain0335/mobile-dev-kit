---
name: release-check
description: Google Play and App Store readiness checklist with the mobile-release skill. Read-only.
argument-hint: "[android|ios|all]"
allowed-tools: Bash(git branch --show-current)
disable-model-invocation: true
---

Check store readiness for the next release. Do not edit any file.

Current branch: !`git branch --show-current`

If the line above shows a command instead of its output, run it first.

1. Platforms: `$ARGUMENTS` if given (`android`, `ios` or `all`), otherwise every platform the repository builds.
2. Delegate to the `mobile-release-checker` agent of this plugin with the platforms. If agents are not available, apply the `mobile-release` skill yourself,
   read-only.
3. Show the checklist as returned, then the blockers. Items that only the store consoles can confirm are
   listed for manual checking, not marked as passed.
