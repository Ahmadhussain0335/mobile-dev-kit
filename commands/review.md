---
name: review
description: Review the current branch against its merge base with the mobile-code-review skill. Read-only.
argument-hint: "[base-branch]"
allowed-tools: Bash(git branch --show-current) Bash(git status --short)
disable-model-invocation: true
---

Review the changes on the current branch. Do not edit any file.

Current branch: !`git branch --show-current`
Working tree: !`git status --short`

If the two lines above show commands instead of their output, run them first.

1. Base branch: `$ARGUMENTS` if given. Otherwise the remote default branch from
   `git symbolic-ref --short refs/remotes/origin/HEAD`, falling back to `main`.
2. Collect `git diff --merge-base <base> --name-only`, `git diff --merge-base <base> --stat` and the full
   `git diff --merge-base <base>`. Mention uncommitted changes from the working tree separately.
3. Delegate to the `mobile-reviewer` agent of this plugin,
   passing the base branch, the file list and the diff. If agents are not available, apply the
   `mobile-code-review` skill yourself, read-only.
4. Show the review report as returned, ending with the verdict.
