# Changelog

All notable changes to this project are documented in this file.
The format is based on Keep a Changelog, and this project uses Semantic Versioning.
One version number covers the skills, every tool manifest and the CLI packages.

## 1.0.0

- Initial release.
- Twelve Agent Skills: `mobile-code-review`, `mobile-security`, `mobile-ci-cd`, `mobile-merge-request`,
  `mobile-mvvm`, `mobile-mvi`, `mobile-mvc`, `mobile-design-patterns`, `mobile-kotlin`, `mobile-java`,
  `mobile-swift` and `mobile-flutter`.
- The language skills were renamed before release so every skill starts with `mobile-` and none clashes
  with other packs: `kotlin-android` is now `mobile-kotlin`, `java-android` is `mobile-java`, `swift-ios`
  is `mobile-swift` and `dart-flutter` is `mobile-flutter`.
- Manifests for Claude Code (plugin and marketplace), OpenAI Codex, Cursor, Gemini CLI, GitHub Copilot CLI
  and the Agent Plugins format, plus `AGENTS.md` and `GEMINI.md`.
- `mobile_dev_kit` Dart CLI on pub.dev and `mobile-dev-kit` npm CLI: `list`, `targets`, `install`,
  `uninstall` and `doctor` for eight tools, with marker-based safe uninstall.
- Per-skill zips for Claude.ai and ChatGPT upload, attached to each GitHub Release.
