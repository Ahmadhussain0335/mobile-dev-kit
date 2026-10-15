---
type: llm
---

PASS if the response identifies that a server-side payments secret is compiled into the app through
`buildConfigField` / `BuildConfig.PAYMENTS_API_SECRET`, rates it Critical or High, and recommends moving the
secret to a backend (short-lived, user-scoped tokens issued by the server) and rotating it.
FAIL if the secret in BuildConfig is not reported, or if the main fix offered is only obfuscation.
