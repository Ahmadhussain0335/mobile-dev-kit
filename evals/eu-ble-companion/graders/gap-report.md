---
type: llm
---

PASS if the response contains a gap table with a status per requirement (Met, Partial, Missing or Not
applicable) and covers at least: the skippable password (EN 18031 restriction on clauses 6.2.5.1/6.2.5.2 or CRA
Annex I authentication), firmware fetched over HTTP and checked only by CRC (secure update / integrity), and the
missing vulnerability reporting contact or disclosure policy (CRA Annex I Part II).
FAIL if any of those three gaps is missing or there is no per-requirement status.
