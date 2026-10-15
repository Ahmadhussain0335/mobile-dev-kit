# Security policy

## Reporting a vulnerability

Report vulnerabilities privately through GitHub:
[Security > Report a vulnerability](https://github.com/Ahmadhussain0335/mobile-dev-kit/security/advisories/new).
Do not open a public issue.

Please include the affected component (a skill, a plugin manifest, an agent or command, the `mobile_dev_kit` Dart
CLI or the `mobile-dev-kit` npm CLI), the version, steps to reproduce and the impact.

## What to expect

- Acknowledgement within 5 working days.
- Updates while the report is investigated and fixed.
- A GitHub security advisory once a fix is released, crediting you if you wish.

## Scope

In scope:
- The CLIs writing or deleting files outside the skill folders they manage, following symbolic links, or
  mishandling the `.mobile-dev-kit.json` marker.
- Plugin manifests, agents or commands that grant more access than documented, for example broad `allowed-tools`.
- Skill guidance that, if followed, introduces a security vulnerability.
- The release and publishing workflows.

Out of scope: vulnerabilities in the AI tools themselves (report those to their vendors) and issues in apps
built with advice from these skills.

## Supported versions

Security fixes are released for the latest published version.
