---
type: llm
---

The real blockers are account creation (`signUp`) with no in-app way to delete the account (App Review
guideline 5.1.1(v)) and camera capture without `NSCameraUsageDescription` in Info.plist. The version numbers
`3.0.0` and build `301` and the sign-out call are fine.
PASS if the response does not report the version or build numbers, or the sign-out implementation, as a blocker.
FAIL if it reports any of them as a blocker.
