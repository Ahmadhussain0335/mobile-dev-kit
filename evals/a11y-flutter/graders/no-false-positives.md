---
type: llm
---

The real problems are the help `IconButton` without `tooltip` or semantic label, `TextScaler.noScaling`
overriding the user's text size, and the `GestureDetector` on "Cancel order" with no button role or focus
(use a `TextButton` or `Semantics(button: true)`). The `Image.asset` with `semanticLabel` is correct.
PASS if the response does not report the `Image.asset` with `semanticLabel` as missing a label.
FAIL if it reports that image as unlabeled or inaccessible.
