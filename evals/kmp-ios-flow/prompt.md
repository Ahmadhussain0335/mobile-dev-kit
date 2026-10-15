---
description: KMP iOS interop: consuming a Kotlin StateFlow from SwiftUI with a coroutines bridge instead of a leaking manual collector.
tags: [kmp, ios, swift]
max_turns: 25
timeout_seconds: 600
allowed_tools: [Read, Glob, Grep, Skill]
---

Our SwiftUI screen observes a Kotlin StateFlow from the shared module (code in the `fixture` directory). It leaks and sometimes updates the UI from a background thread. How should we do this properly?
