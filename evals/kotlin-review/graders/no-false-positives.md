---
type: llm
---

The fixture has three real problems: `GlobalScope.launch` in `DeviceViewModel.refresh`, `collectAsState()`
without lifecycle awareness in `DeviceScreen`, and a stored Activity Context in `ConnectionTracker`.
`viewModelScope.launch` in `rename`, the `LazyColumn` with `key = { it.id }` and the data classes in
`DeviceUiState.kt` are correct.

PASS if the response does not report any of the correct items as a bug of Major or Blocker severity.
FAIL if it reports `viewModelScope.launch` in `rename`, the keyed `LazyColumn` or the `DeviceUiState` data
classes as a Major or Blocker problem.
