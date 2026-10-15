---
description: Android startup review measures first and moves synchronous Application.onCreate work off the critical path.
tags: [performance, android]
max_turns: 25
timeout_seconds: 600
allowed_tools: [Read, Glob, Grep, Skill]
---

Users complain that our Android app takes a long time to open. The startup code is in the `fixture` directory. What should we do?
