---
type: llm
---

The real problems are writes `.withoutResponse` in a tight loop without checking `canSendWriteWithoutResponse`
or waiting for `peripheralIsReady(toSendWriteWithoutResponse:)`, a hardcoded 20-byte chunk instead of
`maximumWriteValueLength(for:)`, and the missing `NSBluetoothAlwaysUsageDescription` in Info.plist.
Creating `CBCentralManager` with a dedicated `queue` and scanning with a service UUID filter are correct.
PASS if the response does not report the dedicated delegate queue or the filtered scan as a problem.
FAIL if it reports either as a problem.
