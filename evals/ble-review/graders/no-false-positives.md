---
type: llm
---

The real problems are two `writeCharacteristic` calls back to back with no operation queue (the second fails
while the first is in flight, and the return status is ignored), and the missing `BLUETOOTH_CONNECT` permission
that GATT operations need on Android 12+, hidden by `@SuppressLint("MissingPermission")`. `BLUETOOTH_SCAN` with
`neverForLocation` and the `bluetooth_le` feature are correct.
PASS if the response does not report the `neverForLocation` scan permission or the `uses-feature` entry as a bug.
FAIL if it reports either of them as a bug.
