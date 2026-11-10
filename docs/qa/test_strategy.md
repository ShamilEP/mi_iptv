# Mi IPTV — Client Test Strategy & Plan (QA-001)

**Scope:** Flutter clients in this repository only — Android TV / Google TV (primary) and Companion (Android / iOS).  
**Out of scope here:** Backend API certification, infrastructure SLOs, and Product backlog decisions (tracked elsewhere).  
**Authority:** Derived for client execution from tracker QA-001 / SRS §22 themes (entry/exit per phase, defect process, severity). Where SRS §22 and this doc diverge, prefer the external SRS and update this file.

Related engineering rules: [`.cursor/rules/testing.mdc`](../../.cursor/rules/testing.mdc), [`AGENTS.md`](../../AGENTS.md).  
Defect workflow & release go/no-go: [defect_tracking.md](./defect_tracking.md), [release_checklist.md](./release_checklist.md) (QA-005).  
Client security acceptance criteria: [client_security_checklist.md](../security/client_security_checklist.md) (SEC-002).

---

## 1. Objectives

1. Prove Clean Architecture boundaries and brand/UI contracts before feature depth grows.
2. Prevent regressions on TV D-pad focus, the 12 mandatory UI states, and Companion send-to-TV (no Companion video playback in MVP).
3. Keep secrets, credentials, and PII out of logs and test fixtures.
4. Gate each delivery phase with explicit entry/exit criteria and a shared defect severity model.

---

## 2. Test pyramid (client)

| Layer | What | Where | Notes |
|---|---|---|---|
| Unit | Domain entities, use cases, pure helpers (`ColorContrast`, parsers) | `test/**` without Flutter binding when possible | Fake adapters/repos; never hit real network or secure storage |
| Widget | Shared `lib/core/widgets`, focus/empty/error/offline chrome, critical screens | `test/core/**`, `test/features/**` | Mirror `lib/features/<name>/...` |
| Integration / device | TV Leanback flows, Companion browse + send-to-TV, auth against staging | Manual + future `integration_test` (package only after approval) | HTTPS staging only; no production secrets in CI |
| Static | Analyzer + format conventions | `flutter analyze` | Required on every task branch |

**Not yet approved:** `mockito` / `mocktail` / golden toolkits — use hand-rolled fakes until explicitly approved.

**Security bar for tests:** no JWT, passwords, Xtream/M3U credentials, or refresh tokens in fixtures or logs.

---

## 3. Environments

| Environment | Purpose | Client constraints |
|---|---|---|
| Local | Developer unit/widget tests | Fakes; `AppTheme.tvDark()` / `companionLight()` |
| CI (PR) | Analyze + unit/widget suite | No device farm required for Sprint 0 |
| Staging | Auth, catalog, sync, QoE smoke | TLS only; anonymous QoE IDs; test accounts only |
| Release candidate | MVP / Release 1 exit | TV 1080p focus distance + Companion phones/tablets |

Backend/infra availability is an **entry** dependency, not owned by this repo.

---

## 4. Phases — entry & exit criteria

### 4.1 Sprint 0 (foundations)

**Entry**

- Repo builds; `flutter analyze` and `flutter test` runnable on `main`.
- Brand tokens and mandatory UI-state catalog land (or are in review) per Design Sprint 0 tasks.
- No open **Blocker** defects on harness / CI smoke.

**In-phase testing**

- Theme, typography, focus, content cards/rows, controls, overlays contracts.
- Accessibility contrast pairs locked in tests (`color_contrast_test.dart`).
- TV 2–3 m legibility, contrast, and focus visibility (`tv_distance_legibility_test.dart`, QA-037).

**Exit**

- Analyze clean; full unit/widget suite green on `main`.
- Shared widgets cover the 12 `UiState`s where Design DoD requires it.
- Sprint 0 Design/QA/Security client tasks either **Done** or explicitly **Blocked** with owner note.
- Zero open **Blocker** / **Critical** defects filed against Sprint 0 foundations.
- Test strategy (this document) reviewed and **Done**.

### 4.2 MVP

**Entry**

- Sprint 0 exit met (or waiver recorded by human reviewer).
- Staging auth + catalog contracts available for client adapters.
- Feature branches map to MVP features: `auth`, `home`, `live_tv`, `player`, `catalog`, `sources`, `sync`, `devices`, `search`, `settings`, `favorites`.

**In-phase testing**

- Unit tests for use cases (login, refresh, sync LWW / playback position rules).
- Widget tests for TV Home, Live, Player overlays, Companion browse/send-to-TV.
- Manual TV D-pad pass: focus ring always visible; first focus on highest-priority control.
- Manual Companion pass: no video playback; send-to-TV happy path + offline messaging.
- Negative paths: stream failure + retry, sync conflict toast, offline/empty/error states.

**Exit**

- All MVP feature DoDs for client sheets met or waived in writing.
- Analyze + automated suite green; smoke on staging TV + one Companion OS.
- No open **Blocker** / **Critical** defects; **Major** defects have owners and target builds.
- Security checklist items applicable to the client (QA/SEC tasks) addressed or tracked.
- Out-of-MVP explicitly untested as release scope: EPG grid, multi-profile, Companion playback, social login, Smart TV.

### 4.3 Release 1 (post-MVP)

**Entry**

- MVP exit met.
- Release 1 Design/feature scope agreed externally (e.g. EPG, profiles) without inventing Product decisions in this doc.

**In-phase testing**

- Expand coverage for Release 1 client surfaces only.
- Regression of MVP smoke on every RC.

**Exit**

- RC analyze + tests green; Release 1 client DoDs Done or waived.
- No open **Blocker** / **Critical**; remaining **Major** accepted by human reviewer for ship.
- Defect backlog groomed; severity taxonomy unchanged unless SRS updates.

---

## 5. Defect process

Canonical workflow, fields, labels, and severities: **[defect_tracking.md](./defect_tracking.md)** (QA-005). Summary below stays aligned with that doc.

### 5.1 Intake

1. Reproduce on a named build (`main` SHA or task branch) and device class (TV / Companion).
2. File with: steps, expected vs actual, logs **scrubbed of secrets**, severity (below), phase, feature id if known.
3. Link related tracker task when the defect blocks DoD.

### 5.2 Workflow states

`New` → `Triaged` → `In progress` → `In review` → `Done`  
Alternate: `Blocked` (external dependency), `Won’t fix` (human decision only).

Client agents do **not** mark Product/Backend/Infra rows; they file client defects and Blocked notes on client tasks.

### 5.3 Severity definitions

| Severity | Definition | Examples (client) | Ship rule |
|---|---|---|---|
| **Blocker** | App unusable or unsafe on a target platform; no workaround | Crash on launch; cannot complete login on staging; secrets logged | Must fix before phase exit |
| **Critical** | Core MVP journey broken; workaround painful or none | Live tune fails always; send-to-TV never delivers; focus invisible on TV | Must fix before phase exit |
| **Major** | Important feature impaired; reasonable workaround exists | Overlay mis-timed; one source type parse fail; Companion keyboard gap | Exit allowed only with owner + target build |
| **Minor** | Polish / limited impact | Spacing drift; non-blocking copy | Does not hold phase exit |
| **Trivial** | Cosmetic nit | Typo in debug-only string | Backlog |

Severity is about **user/security impact**, not effort.

### 5.4 Priority vs severity

- **Severity** = impact (table above).  
- **Priority** = schedule order (P0–P3), set during triage. A **Minor** can be P0 before a demo; a **Major** can be P2 if workaround is solid.

### 5.5 Release go / no-go

Per-RC checklist: **[release_checklist.md](./release_checklist.md)**. Open Blocker/Critical ⇒ automatic no-go.

---

## 6. Definition of done (per client task)

1. DoD from the tracker task satisfied.  
2. `flutter analyze` clean; `flutter test` green.  
3. New logic covered at the appropriate pyramid layer.  
4. No secrets in code, fixtures, or logs.  
5. Verifier pass (when using `/execute-next-task`).  
6. Status → **In review** with branch/notes; **Done** only after human approval.

---

## 7. Traceability

| Phase gate | Evidence |
|---|---|
| Sprint 0 exit | Green CI/local suite; Design foundation tasks Done; this plan Done |
| MVP exit | Feature DoDs + staging smoke checklist (TV + Companion) |
| Release 1 exit | RC notes + regression of MVP smoke |

Automated suite layout mirrors code: `test/core/...`, future `test/features/<feature>/...`.

---

## 8. Open dependencies (not decided here)

- Exact staging URLs and device farm (Infra).  
- Bug tracker of record for client defects: GitHub Issues on this repo by default ([defect_tracking.md](./defect_tracking.md)); org-wide board mapping is an Infra/Process choice.  
- Formal SRS §19 / §22 wording — keep QA docs aligned when the external spec is edited.  
- Approval for integration_test / golden / mock packages.
