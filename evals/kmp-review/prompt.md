---
description: KMP review finds JVM and Android APIs in commonMain and a suspend function exported to Swift without @Throws.
tags: [kmp, kotlin, review]
max_turns: 25
timeout_seconds: 600
allowed_tools: [Read, Glob, Grep, Skill]
---

Review the shared Kotlin Multiplatform module in the `fixture` directory. The iOS team says it does not build for them and some errors crash the app.
