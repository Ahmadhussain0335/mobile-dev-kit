# EU compliance notes for mobile and IoT companion apps

Load this when the app is placed on the EU market, processes personal data of people in the EU, or
controls a connected (radio) device. These notes help an engineering audit produce useful evidence.
They are not legal advice: flag legal questions for the user's compliance or legal team, and check the
current Official Journal text and harmonised-standard citations before quoting dates or clauses.

## GDPR (Regulation (EU) 2016/679)

- Personal data includes online identifiers (Art. 4(1), Recital 30). Treat MAC addresses, device serials,
  IMEI, advertising IDs, `identifierForVendor`, push tokens and IP addresses as personal data when they
  can be linked to a person, which is the normal case for a device owned by one user.
- Pseudonymised data is still personal data. Only anonymised data is out of scope, and hashing a MAC
  address is not anonymisation.
- Data minimisation (Art. 5(1)(c)) and data protection by design and by default (Art. 25) apply to code:
  collect only the fields a feature needs, keep optional telemetry off until the user opts in where consent
  is the legal basis, and set retention.
- Security of processing (Art. 32): encryption in transit and at rest, access control, logging without
  personal data.
- User rights need a working path: data export and account and data deletion, including data held by
  the device cloud.

Audit checks:
- [ ] Telemetry payloads list every field and its purpose; direct identifiers removed or justified
- [ ] Third-party SDKs (analytics, crash reporting, ads) reviewed for what they collect and where they send it
- [ ] Logs, crash reports and analytics events contain no identifiers or location unless justified
- [ ] Deletion removes data in the app, the backend and the device pairing records

## Cyber Resilience Act (Regulation (EU) 2024/2847)

Applies to products with digital elements made available on the EU market, which includes software such
as mobile apps supplied in the course of a commercial activity, and connected hardware. Obligations phase in:

| Date | What applies |
|---|---|
| 10 December 2024 | Regulation entered into force |
| 11 September 2026 | Reporting of actively exploited vulnerabilities and severe incidents (Art. 14) |
| 11 December 2027 | All remaining obligations, including essential requirements and conformity assessment |

Reporting already applies to products on the market, including those placed before December 2027.

What it means for a mobile or companion-app codebase:
- Secure by default configuration, no known exploitable vulnerabilities at release, protection of
  confidentiality and integrity of data, minimised attack surface, security logging where relevant.
- Vulnerability handling: a coordinated vulnerability disclosure policy and contact, a process to triage
  and fix reported issues, and security updates delivered for the declared support period.
- SBOM: identify and document components, at least top-level dependencies, in a commonly used
  machine-readable format (CycloneDX or SPDX). Generate it per release from lock files.
- Reporting: actively exploited vulnerabilities and severe incidents are reported to the authorities
  (CSIRT / ENISA single reporting platform) on short deadlines; the team needs a ready process.
- Technical documentation and a risk assessment are part of conformity; audit findings and fixes feed it.

Audit checks:
- [ ] SBOM generated per release and archived with the build
- [ ] Dependency scanning in CI with a policy for fixing known vulnerabilities
- [ ] Forced-update or minimum-version mechanism exists (MASVS-CODE-2)
- [ ] `SECURITY.md` or equivalent disclosure contact exists for the product
- [ ] Support period and update channel documented

## RED Delegated Act (Regulation (EU) 2022/30) and EN 18031

- Applies from 1 August 2025 to radio equipment (Wi-Fi, BLE, cellular devices) placed on the EU market,
  under the essential requirements of RED Article 3(3)(d) network protection, (e) personal data and
  privacy protection and (f) protection from fraud.
- EN 18031-1, -2 and -3 are the harmonised standards for these three articles. Their citation in the
  Official Journal carries restrictions; where a restriction applies, presumption of conformity may not
  hold and a notified body route may be needed.
- The companion app is not itself radio equipment, but it often implements the device's security
  mechanisms: authentication to the device, access control, secure update delivery, secure communication,
  storage of credentials and user-initiated deletion. Those app features are assessed as part of the device.

Mechanism areas EN 18031 covers that usually touch the app:
- Access control and authentication: no universal default passwords, per-device credentials, brute-force
  protection on pairing or PIN entry.
- Secure update: firmware images delivered over TLS and verified on the device (signature), not only by CRC.
- Secure storage and communication: keys and credentials in Keystore / Keychain, TLS to cloud and brokers,
  authenticated and encrypted BLE commands.
- Logging, deletion and user notification: user can reset and delete data from the device and app.

## ETSI EN 303 645 (consumer IoT baseline)

Thirteen provisions, several directly checkable in a companion app audit:
- No universal default passwords.
- Implement a means to manage reports of vulnerabilities.
- Keep software updated.
- Securely store sensitive security parameters.
- Communicate securely.
- Minimise exposed attack surfaces.
- Ensure software integrity.
- Ensure that personal data is secure.
- Make systems resilient to outages.
- Examine system telemetry data.
- Make it easy for users to delete user data.
- Make installation and maintenance of devices easy.
- Validate input data.

## Mapping to MASVS v2

| Requirement area | MASVS controls |
|---|---|
| Secure storage of credentials and keys | MASVS-STORAGE-1, MASVS-CRYPTO-2 |
| Secure communication (cloud, MQTT, BLE) | MASVS-NETWORK-1, MASVS-NETWORK-2 |
| Authentication and access control | MASVS-AUTH-1, MASVS-AUTH-2, MASVS-AUTH-3 |
| Input validation (deep links, device payloads) | MASVS-CODE-4, MASVS-PLATFORM-1 |
| Known vulnerabilities, SBOM, updates | MASVS-CODE-3, MASVS-CODE-2 |
| Data minimisation, transparency, deletion | MASVS-PRIVACY-1 to MASVS-PRIVACY-4 |

In the report, put compliance observations in the "Compliance notes" section, linked to the technical
finding that supports them. Do not state that a product "is compliant"; state what the audit found.
