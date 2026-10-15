---
type: llm
---

The real problems are `android.content.Context` and `java.io.File` used in `commonMain` (they do not exist on
iOS; use an interface with platform implementations or a multiplatform file API), and `suspend fun refresh()`
exposed to Swift without `@Throws`, so an exception crashes instead of becoming a Swift error. The small
`expect fun platformName()` with its two `actual` implementations is an appropriate use of expect/actual.
PASS if the response does not report the `platformName` expect/actual as a problem.
FAIL if it reports that expect/actual as a problem or says it must be replaced.
