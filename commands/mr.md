---
name: mr
description: Write the merge request or pull request description for the current branch with the mobile-merge-request skill.
argument-hint: "[base-branch]"
allowed-tools: Bash(git branch --show-current) Bash(git status --short)
disable-model-invocation: true
---

Write the MR or PR description for the current branch. Do not push, create the MR or edit files.

Current branch: !`git branch --show-current`
Working tree: !`git status --short`

If the lines above show commands instead of their output, run them first.

1. Base branch: `$ARGUMENTS` if given, otherwise the remote default branch from
   `git symbolic-ref --short refs/remotes/origin/HEAD`, falling back to `main`.
2. Collect `git log --oneline <base>..HEAD`, `git diff --merge-base <base> --stat` and the diff of files whose
   purpose is unclear from their names.
3. Apply the `mobile-merge-request` skill: its MR description template, branch and commit checks, and output
   format. Take the ticket key from the branch name if it contains one.
4. Leave placeholders for screenshots, recordings and anything that cannot be known from the code (manual
   test results, rollout plan) instead of inventing them.
5. Print the description as Markdown, ready to paste.
