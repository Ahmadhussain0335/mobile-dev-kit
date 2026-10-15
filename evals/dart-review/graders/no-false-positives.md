---
type: llm
---

The real problems are `context` used after `await` without a `mounted` check, the `TextEditingController` never
disposed, missing `const` on `Text`, `SnackBar`, `EdgeInsets.all` and the `AppBar` title, and the API key in
source. `ProfileException`, the `const ProfilePage` constructor, `Uri.https` and the status-code check are fine.
PASS if the response does not report `ProfileException`, the `const ProfilePage` constructor or `Uri.https`
as a Major or Blocker problem.
FAIL if it reports any of those as a Major or Blocker problem.
