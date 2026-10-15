---
type: llm
---

The real problem is storing access and refresh tokens in `UserDefaults`. The HTTPS token endpoint and the
use of `URLSession` with async/await are fine.
PASS if the response does not report the HTTPS endpoint as cleartext or insecure, and does not rate the
async/await networking itself as a security finding.
FAIL if it reports the HTTPS URL as cleartext traffic or rates async networking as a security finding.
