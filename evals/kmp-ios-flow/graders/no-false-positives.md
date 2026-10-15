---
type: llm
---

The real problems are a manual `FlowCollector` started in `onAppear` that is never cancelled, values applied
to SwiftUI state without hopping to the main actor, a force cast, and the ViewModel recreated with the view.
The Kotlin `CounterViewModel` exposing a read-only `StateFlow` is correct.
PASS if the response does not report the Kotlin `CounterViewModel` StateFlow design as a problem.
FAIL if it says the Kotlin ViewModel itself must be redesigned or reports it as the cause.
