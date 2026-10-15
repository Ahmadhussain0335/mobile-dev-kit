---
type: llm
---

The real problems are `ListView(children: ...)` building every item eagerly, `jsonDecode` running inside
`build` on every rebuild, and full-size network images without `cacheWidth`. The `const FeedPage` constructor
is fine.
PASS if the response does not report the `const` constructor as a problem and does not present invented frame
timings as measured results.
FAIL if it reports the constructor as a problem or presents invented measurements as results.
