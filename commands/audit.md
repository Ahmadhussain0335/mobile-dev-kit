---
name: audit
description: Security and EU compliance audit (mobile-security and mobile-eu-compliance). Writes reports/security-audit-<date>.md.
argument-hint: "[path or module]"
allowed-tools: Bash(date +%F) Bash(git branch --show-current)
disable-model-invocation: true
---

Run a security and EU compliance audit and save the report. Do not change any source file.

Today: !`date +%F`
Current branch: !`git branch --show-current`

If the lines above show commands instead of their output, run them first.

1. Scope: `$ARGUMENTS` if given, otherwise the whole repository. Note platforms, any connected device and
   whether the product is sold in the EU, from the README and build files.
2. Delegate to the `mobile-security-auditor` agent of this plugin with the scope. If agents are not available, apply the `mobile-security` skill and then
   the `mobile-eu-compliance` skill yourself, read-only.
3. Write the returned report to `reports/security-audit-<today>.md`. Create `reports/` if needed. If the file
   exists, add a suffix such as `-2` instead of overwriting it.
4. Print the file path, the count of findings per severity and the top three gaps. Remind the user that the
   compliance part is engineering guidance, not legal advice, and that `reports/` may need to be git-ignored
   if findings must stay private.
