# Sources

Official documentation used to write the tool manifests and the CLI install targets.
Plugin formats change often; re-check these pages before changing a manifest.

Last checked: 2026-10-15.

## Agent Skills format

| Topic | URL |
|---|---|
| Agent Skills specification (`SKILL.md` frontmatter, name rules, 1024-char description, 500-line guidance) | https://agentskills.io/specification |
| Agent Plugins specification 1.0.0 (root `plugin.json`, `$schema`, fixed `skills/` location) | https://agent-plugins.org/specification |

## Claude Code

| Topic | URL |
|---|---|
| Create a marketplace, `claude plugin validate`, local install loop | https://code.claude.com/docs/en/plugin-marketplaces.md |
| Marketplace reference (top-level fields, reserved names, relative `source`) | https://code.claude.com/docs/en/plugins/marketplace-reference.md |
| Plugin manifest reference (`.claude-plugin/plugin.json`, default `skills/` scan) | https://code.claude.com/docs/en/plugins-reference.md |

## OpenAI Codex

| Topic | URL |
|---|---|
| Build plugins (portable root `plugin.json`, `.codex-plugin/plugin.json` fallback, `.agents/plugins/marketplace.json`) | https://developers.openai.com/codex/plugins/build.md |
| Skills discovery paths (`.agents/skills`, `~/.agents/skills`) | https://learn.chatgpt.com/docs/build-skills.md (redirect target of https://developers.openai.com/codex/skills.md) |

## Gemini CLI

| Topic | URL |
|---|---|
| Extension reference (`gemini-extension.json`, `contextFileName`, `skills/` in extensions, install and link) | https://geminicli.com/docs/extensions/reference.md |
| Skills discovery (`.gemini/skills`, `.agents/skills`, `~/.gemini/skills`, `~/.agents/skills`) | https://geminicli.com/docs/cli/skills.md |

## GitHub Copilot

| Topic | URL |
|---|---|
| Copilot CLI plugin reference (manifest lookup order, Agent Plugins precedence, marketplace locations, skill paths) | https://docs.github.com/en/copilot/reference/copilot-cli-reference/cli-plugin-reference |
| Creating skills (`.github/skills`, `.claude/skills`, `.agents/skills`, `~/.copilot/skills`, `~/.agents/skills`) | https://docs.github.com/en/copilot/how-tos/use-copilot-agents/cloud-agent/create-skills |

## Cursor

| Topic | URL |
|---|---|
| Skills (`.agents/skills`, `.cursor/skills`, `~/.cursor/skills`, compatibility directories) | https://cursor.com/docs/skills |
| Plugins reference (`.cursor-plugin/plugin.json`, multi-plugin `marketplace.json`, submission checklist) | https://cursor.com/docs/reference/plugins |
| Plugins overview (install paths, single-plugin repositories) | https://cursor.com/docs/plugins |

## Google Antigravity

| Topic | URL |
|---|---|
| Skills (`.agents/skills`, `~/.gemini/config/skills`, CLI and legacy paths) | https://antigravity.google/docs/skills |

## Windsurf (Devin Desktop)

| Topic | URL |
|---|---|
| Cascade skills (`.devin/skills`, legacy `.windsurf/skills`, `.agents/skills`, `~/.codeium/windsurf/skills`) | https://docs.devin.ai/desktop/cascade/skills (redirect target of https://docs.windsurf.com/windsurf/cascade/skills) |

## Dart and pub.dev

| Topic | URL |
|---|---|
| CLI distribution (`dart install`, AOT, `executables:`) | https://dart.dev/tools/cli-distribution |
| Automated publishing from GitHub Actions (OIDC, tag pattern, environments) | https://dart.dev/tools/pub/automated-publishing |

## npm

| Topic | URL |
|---|---|
| Trusted publishing with GitHub Actions (OIDC, automatic provenance, npm 11.5.1+) | https://docs.npmjs.com/trusted-publishers |

## Skill zip uploads

| Topic | URL |
|---|---|
| Claude.ai skill packaging (`<skill>/SKILL.md` as the top-level folder of the zip) | https://claude.com/docs/skills/how-to.md |
| OpenAI skills bundles (one top-level folder, one `SKILL.md` per bundle) | https://developers.openai.com/api/docs/guides/tools-skills |
