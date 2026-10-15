---
description: Flutter jank review finds an eager list of thousands of items and JSON decoding in build, and asks for profile-mode measurement.
tags: [performance, flutter]
max_turns: 25
timeout_seconds: 600
allowed_tools: [Read, Glob, Grep, Skill]
---

Scrolling the feed in our Flutter app is janky on mid-range Android phones. Code is in the `fixture` directory. How do we fix it?
