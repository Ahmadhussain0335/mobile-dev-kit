## 1.0.1

- Fixed: the symbolic-link check before writing or deleting files now also stops at the filesystem root, so an
  unexpected path can never make it loop.
- Tests now pass on Windows and on Dart 3.5, the minimum supported SDK.

## 1.0.0

- Initial release.
- Embeds the mobile-dev-kit Agent Skills: `mobile-code-review`, `mobile-security`, `mobile-eu-compliance`,
  `mobile-ci-cd`, `mobile-merge-request`, `mobile-mvvm`, `mobile-mvi`, `mobile-mvc`, `mobile-design-patterns`, `mobile-kotlin`, `mobile-java`,
  `mobile-swift`, `mobile-flutter`, `mobile-kmp`, `mobile-ble`, `mobile-accessibility`, `mobile-release`,
  `mobile-testing` and `mobile-performance`.
- Commands: `list`, `targets`, `install`, `uninstall`, `doctor`, `--version`, `--help`.
- Targets: Claude Code, Codex, Gemini CLI, GitHub Copilot, Cursor, Google Antigravity, Windsurf and any tool
  that reads `.agents/skills`.
