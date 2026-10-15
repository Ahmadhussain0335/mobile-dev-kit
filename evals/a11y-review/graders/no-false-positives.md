---
type: llm
---

The real problems are the delete `IconButton` whose `Icon` has `contentDescription = null` (no accessible
name, WCAG 4.1.2 / 1.1.1) and the name text sized with `14.dp.toSp()`, which ignores the user's font scale
(WCAG 1.4.4). `Text(price, fontSize = 14.sp)` scales correctly and `IconButton` provides a 48dp touch target.
PASS if the response does not report `fontSize = 14.sp` as ignoring font scaling, and does not report the
`IconButton` touch target as too small.
FAIL if it reports either of them as a problem.
