# Mi IPTV — Client Release Go / No-Go Checklist (QA-005)

**Scope:** Flutter clients (Android TV / Google TV + Companion).  
**Defect workflow:** [defect_tracking.md](./defect_tracking.md).  
**Phase strategy:** [test_strategy.md](./test_strategy.md).  
**Security controls:** [client_security_checklist.md](../security/client_security_checklist.md) (SEC-002).  
**Incidents:** [incident_response_runbook.md](../security/incident_response_runbook.md) (SEC-052).

Use one copy of this checklist **per release candidate** (Sprint 0 foundation exit, MVP ship, Release 1 RC).  
Record build SHA, date, and reviewer name. Any unchecked **Must** item ⇒ **NO-GO**.

---

## Header

| Field | Value |
|---|---|
| Release / phase | Sprint 0 / MVP / Release 1 |
| Candidate build (SHA) | |
| Date (UTC) | |
| Reviewer | |
| Decision | GO / NO-GO |
| Notes / waivers | Human-written only; link issue IDs |

---

## A. Quality gates (Must)

| # | Check | Pass? |
|---|---|---|
| A1 | `flutter analyze` clean on candidate SHA | ☐ |
| A2 | `flutter test` green on candidate SHA | ☐ |
| A3 | No open **Blocker** defects for this client | ☐ |
| A4 | No open **Critical** defects for this client | ☐ |
| A5 | Every open **Major** has owner + target build (or human waiver) | ☐ |
| A6 | No secrets / credentials / PII in logs, fixtures, or release notes | ☐ |
| A7 | SEC-002 checklist §3 Must IDs for shipped surfaces are Pass or human-waived | ☐ |

---

## B. Platform smoke (Must for MVP / Release 1; recommended for Sprint 0)

| # | Check | Pass? |
|---|---|---|
| B1 | **TV:** cold start → focus visible (Cloud ring + Signal glow) on first actionable control | ☐ |
| B2 | **TV:** mandatory UI states exercised where in-scope (empty / error / offline at minimum for shipped surfaces) | ☐ |
| B3 | **Companion:** browse path works; **no video playback** in MVP | ☐ |
| B4 | **Companion:** send-to-TV happy path **or** deferred with explicit human waiver if not yet in build | ☐ |
| B5 | Staging only for networked smoke; TLS; test accounts only | ☐ |

*Sprint 0 may mark B3–B5 N/A if those features are not yet implemented — note N/A in Notes.*

---

## B2. Store submission — Companion (CMP-010)

| # | Check | Pass? |
|---|---|---|
| S1 | Launcher / listing icons from DSN-005 (`app_icon_512`, Android adaptive) | ☐ |
| S2 | Permissions inventory matches [cmp-010](../architecture/cmp-010-companion-store-readiness.md) (`INTERNET` only on Android) | ☐ |
| S3 | Play Data Safety / Apple App Privacy filled from [companion_store_privacy_checklist.md](./companion_store_privacy_checklist.md) | ☐ |
| S4 | Review account provisioned privately per [store_review_account.md](./store_review_account.md) — **no passwords in git** | ☐ |
| S5 | Privacy policy URL + final package IDs attached by Product (PRD-042) or explicitly Blocked | ☐ |

---

## C. Scope honesty (Must)

| # | Check | Pass? |
|---|---|---|
| C1 | Out-of-MVP items not claimed as shipped: EPG grid, multi-profile, Companion playback, social login, Smart TV | ☐ |
| C2 | Client sheets’ in-scope DoDs for this phase are Done or explicitly Blocked / waived by human | ☐ |
| C3 | No invented Product / Backend / Infra decisions in release notes | ☐ |

---

## D. Defect hygiene (Must)

| # | Check | Pass? |
|---|---|---|
| D1 | New RC regressions filed with [required fields](./defect_tracking.md#2-required-issue-fields) | ☐ |
| D2 | Severity taxonomy unchanged (Blocker → Trivial) unless SRS update recorded | ☐ |
| D3 | Known issues list attached (or “none”) | ☐ |

---

## E. Decision

- **GO** — all Must rows for this phase are Pass or documented human waiver.  
- **NO-GO** — any Must failure without waiver; fix or re-cut RC.

Sign-off: ______________________ (human reviewer)
