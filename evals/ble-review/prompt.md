---
description: BLE review finds back-to-back GATT writes without an operation queue and a missing BLUETOOTH_CONNECT permission.
tags: [ble, android, review]
max_turns: 25
timeout_seconds: 600
allowed_tools: [Read, Glob, Grep, Skill]
---

Our Android app talks to a sensor over Bluetooth Low Energy. Review the BLE code in the `fixture` directory; users report that settings sometimes do not apply.
