---
description: iOS BLE review finds writes without response sent without flow control and a missing Bluetooth usage description.
tags: [ble, ios, review]
max_turns: 25
timeout_seconds: 600
allowed_tools: [Read, Glob, Grep, Skill]
---

Our iOS app streams configuration to a BLE sensor. Some packets get lost. Review the code in the `fixture` directory.
