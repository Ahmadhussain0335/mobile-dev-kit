---
type: llm
---

PASS if the response reports that `_apiKey` in `profile_api.dart` is a secret shipped in the app source, and
recommends moving it server-side or out of the client (and rotating it).
FAIL if the hardcoded API key is not reported.
