---
type: llm
---

PASS if the response says that `ConnectionTracker` keeps an Activity or Context in a singleton or object
(`lateinit var context`) and that this leaks the Activity, and suggests the application context, an injected
application-scoped dependency, or not storing it.
FAIL if the context leak in `ConnectionTracker.kt` is not mentioned.
