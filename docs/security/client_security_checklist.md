# Mi IPTV — Client Security Checklist (SEC-002)

**Scope:** Flutter clients only (Android TV / Google TV + Companion).  
**Source controls:** [`.cursor/rules/security-client.mdc`](../../.cursor/rules/security-client.mdc), [`AGENTS.md`](../../AGENTS.md). External **Security §1** wins on conflict — update this file when the Cybersecurity spec changes.  
**Out of scope:** Backend auth policy, Infra KMS, pen-test scheduling (owning sheets elsewhere).

Each control below is an **acceptance criterion**: attach the control ID to the relevant tracker task DoD / Notes, and re-check at every sprint review (§5).

Related: [incident response runbook](./incident_response_runbook.md) (SEC-052), [Android TV local storage review](./android_tv_local_storage_review.md) (SEC-021), [Companion local storage review](./companion_local_storage_review.md) (SEC-022), [QA release go/no-go](../qa/release_checklist.md) (A6 secrets bar), [defect tracking](../qa/defect_tracking.md).

---

## 1. How to use

| Step | Action |
|---|---|
| 1 | When claiming a client task in `auth`, `sources`, `sync`, `devices`, `settings`, `player`, or networking adapters, copy applicable **SEC-Cxx** IDs into the task Notes / PR body. |
| 2 | Prove each ID with the listed **Evidence** (test, review, or staging smoke). |
| 3 | Sprint review: walk §3 status table; open/Blocker any failed Must for the in-scope phase. |
| 4 | RC: all **Must** IDs for shipped surfaces are Pass or human-waived with issue link. |

**Evidence types:** `auto` = `flutter test` / analyze · `review` = PR / verifier · `manual` = staging device smoke · `n/a` = feature not in build yet.

---

## 2. Control catalog (testable acceptance criteria)

### 2.1 Secrets & logging — Must

| ID | Acceptance criterion | Attach to | Evidence |
|---|---|---|---|
| **SEC-C01** | Agents and CI never open `*.properties`, `*.env*`, keystore/PEM/P12, or other secret files | All tasks; harness | `review` |
| **SEC-C02** | No JWT, passwords, Xtream/M3U credentials, or refresh tokens in app logs (incl. Logcat) or test fixtures | `auth`, `sources`, logging adapters, tests | `review` + `auto` (fixture grep / contract tests when present) |
| **SEC-C03** | Third-party source passwords are never returned or displayed in UI | `sources`, settings/sources screens | `review` + `manual` |
| **SEC-C04** | No hardcoded API keys, signing secrets, or encryption keys in `lib/` / `test/` | All feature work | `review` |

### 2.2 Transport & storage — Must

| ID | Acceptance criterion | Attach to | Evidence |
|---|---|---|---|
| **SEC-C05** | Client→backend calls use HTTPS / TLS only (no cleartext API base URLs in release configs); user IPTV may use http media with warning (SEC-023) | Network / auth / catalog / sync / player | `review` + `auto` ([network_security_cleartext.md](./network_security_cleartext.md), `TransportSecurityPolicy`) |
| **SEC-C06** | Session tokens persist only through a **secure storage adapter** (Keystore / Keychain behind a domain interface); widgets/use cases never call plugins directly | `auth`, secure-storage data layer | `review` + `auto` (fake adapter in unit tests) |
| **SEC-C07** | Source credentials treated sensitive end-to-end; encrypted at rest if locally cached | `sources`, local cache adapters | `review` |

### 2.3 Input & telemetry — Must

| ID | Acceptance criterion | Attach to | Evidence |
|---|---|---|---|
| **SEC-C08** | User-entered URLs and search strings validated/sanitized at the boundary before use | `sources`, `search`, settings | `auto` (unit) + `review` |
| **SEC-C09** | QoE / crash telemetry uses anonymous IDs only — no email or PII in payloads | Telemetry / diagnostics adapters | `review` + `auto` when serializers exist |

### 2.4 Auth UX (MVP) — Must when auth ships

| ID | Acceptance criterion | Attach to | Evidence |
|---|---|---|---|
| **SEC-C10** | Email/password register, login, refresh, logout, reset-password against `/api/v1/auth/*` only | `auth` feature tasks | `auto` + `manual` staging |
| **SEC-C11** | One profile per account in MVP (no multi-profile UI) | `auth`, profile/settings | `review` |

### 2.5 Sprint-0 harness — Must for Sprint 0 exit

| ID | Acceptance criterion | Attach to | Evidence |
|---|---|---|---|
| **SEC-C12** | Verifier / task DoD includes security bar (no secrets read/logged/hardcoded) | `/execute-next-task` workflow | `review` |
| **SEC-C13** | This checklist exists and is linked from QA release checklist | SEC-002 | `auto` (doc contract test) |

---

## 3. Sprint review board (copy each sprint)

| ID | Status (Pass / Fail / N/A) | Evidence link | Owner |
|---|---|---|---|
| SEC-C01 | | | |
| SEC-C02 | | | |
| SEC-C03 | | | |
| SEC-C04 | | | |
| SEC-C05 | | | |
| SEC-C06 | | | |
| SEC-C07 | | | |
| SEC-C08 | | | |
| SEC-C09 | | | |
| SEC-C10 | | | |
| SEC-C11 | | | |
| SEC-C12 | | | |
| SEC-C13 | | | |

**Cadence:** end of each sprint (and before every RC). Fail on a **Must** for in-scope work ⇒ defect at least **Critical** ([defect_tracking.md](../qa/defect_tracking.md)); secrets exposure ⇒ **Blocker**.

---

## 4. Task attachment map (MVP features)

| Feature / area | Primary control IDs |
|---|---|
| Harness / CI / docs | C01, C04, C12, C13 |
| `auth` | C02, C05, C06, C10, C11 |
| `sources` | C02, C03, C05, C07, C08 |
| `search` | C08 |
| `sync` / `devices` | C05, C06 |
| `settings` / diagnostics | C03, C07, C09 |
| `player` / QoE hooks | C02, C09 |
| All `test/**` | C02, C04 |

Backend rate limits, WAF, and server-side secret rotation stay on Backend/Infra sheets — do not invent them here.

---

## 5. RC quick gate

Before GO on [release_checklist.md](../qa/release_checklist.md):

1. §3 board filled for the phase.  
2. No Fail on Must IDs for shipped surfaces.  
3. A6 (no secrets in logs/fixtures/notes) still Pass.
