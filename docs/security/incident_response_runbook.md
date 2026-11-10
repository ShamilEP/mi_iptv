# Mi IPTV — Client Incident Response Runbook (SEC-052)

**Scope:** Flutter clients only (Android TV / Google TV + Companion).  
**Source controls:** [`.cursor/rules/security-client.mdc`](../../.cursor/rules/security-client.mdc), [`client_security_checklist.md`](./client_security_checklist.md) (SEC-002).  
**External authority:** Cybersecurity / **Security §1** wins on conflict — update this file when that spec changes.  
**Out of scope:** Backend revocation mechanics, Infra KMS rotation, WAF / SIEM playbooks (owning sheets elsewhere). Client responders **coordinate** with those owners; they do not invent server procedures here.

Related: [QA defect tracking](../qa/defect_tracking.md), [release checklist](../qa/release_checklist.md).

---

## 1. When to use this runbook

Trigger on any of:

| Trigger | Examples |
|---|---|
| Session token compromise | Access / refresh JWT leaked in logs, screenshots, support paste, or CI artifact |
| Signing / API key exposure | Keystore password, API key, or encryption key found in `lib/`, git history, or chat |
| Source credential leak | Xtream / M3U password visible in UI, Logcat, fixtures, or release notes |
| Suspected account takeover | User reports unknown devices or unexpected logout loops tied to client behavior |

Severity: secrets exposure ⇒ treat as **Blocker** until contained ([defect_tracking.md](../qa/defect_tracking.md)).

---

## 2. Roles

| Role | Who | Responsibilities |
|---|---|---|
| **Incident lead** | Client tech lead or on-call engineer for this repo | Owns timeline, decides contain → eradicate → recover, updates tracker Notes |
| **Client engineer** | Flutter assignee | Executes client steps (§3): clear secure storage, force logout UX, scrub logs/fixtures, cut hotfix PR |
| **Security contact** | See §5 | Intake, severity call with Incident lead, external notification advice |
| **QA** | QA owner for the RC | Verifies no secrets in builds/logs; re-runs SEC-002 Must IDs; blocks GO until A6 Pass |
| **Backend coordinator** | Backend on-call (out of this repo) | Server-side token revocation, password reset enforcement, account locks — **requested by** Incident lead, not defined here |
| **Product / Comms** | Product owner | User-facing wording for in-app / email / store notices (§4) |

One person may hold multiple roles on a small team; name the **Incident lead** and **Security contact** in the incident Notes within 15 minutes of detection.

---

## 3. Token / key compromise procedure (client)

Execute in order. Do **not** paste live tokens, passwords, or keystore material into tickets, chat, or this repo.

### 3.1 Contain (minutes)

1. **Stop the leak path** — remove or redact the secret from the channel where it appeared (PR, gist, Logcat dump, fixture). Prefer rewrite/purge of git history only with human Infra approval; never force-push `main` without explicit owner instruction.
2. **Force local session clear** — on affected devices / emulators: sign out; wipe app data if sign-out is unavailable. Session tokens must leave **secure storage** only (SEC-C06); never copy them to clipboard for “debugging.”
3. **Halt shipping** — pause release candidates that include the exposure; mark release checklist **NO-GO** until §3.3.
4. **Page Backend coordinator** — request server-side invalidation of the exposed access/refresh tokens and any related API keys. Record the request time and ticket ID; do not invent revocation APIs in the client.

### 3.2 Eradicate (hours)

| Asset compromised | Client actions | Coordinate with |
|---|---|---|
| Access / refresh JWT | Ensure logout clears secure storage; ship hotfix if logout left tokens behind; ban logging of auth headers (SEC-C02) | Backend: revoke sessions / rotate refresh family |
| Account password | Prompt reset-password via `/api/v1/auth/*` when auth UX is shipped (SEC-C10); never display the old password | Backend: invalidate sessions after reset |
| Xtream / M3U credentials | Remove from UI/logs/fixtures; encrypt-at-rest path if cache retained (SEC-C07); user re-enters credentials | User + optional Backend source vault |
| Signing key / keystore secret | Stop using the exposed material; new builds use rotated secrets held **outside** this repo (`*.properties` / CI secrets — never commit) | Infra: rotate store credentials |
| Hardcoded API / encryption key in `lib/` | Delete from source; load via approved config/secure storage adapter; add/extend tests that fail on hardcoded patterns | Infra / Backend for replacement values |

### 3.3 Recover (before next GO)

1. `flutter analyze` + `flutter test` green on the hotfix SHA.  
2. SEC-002 §3 Must IDs for shipped surfaces re-checked (especially C01–C04, C06).  
3. Release checklist A6 (no secrets in logs/fixtures/notes) Pass.  
4. Incident lead files a short postmortem Note on the tracker task / defect: root cause, blast radius, fix SHA, follow-ups.  
5. User notification completed or explicitly deferred by Product (§4).

---

## 4. User notification

| Severity | Notify users? | Channel (MVP) | Message rules |
|---|---|---|---|
| Confirmed account/session compromise | **Yes** | In-app banner or email when auth ships; store listing only if Product requires | State that a session or credential was reset; ask user to sign in again and change password; **never** include tokens or partial secrets |
| Source credential visible on-device | **Yes** (affected accounts) | In-app / support reply | Ask user to rotate the IPTV provider password and re-add the source |
| Internal-only leak (CI secret never shipped) | Usually **no** end-user notice | Security contact + Backend/Infra only | Document decision in incident Notes |
| Suspected but unconfirmed | Hold public notice | Security contact decides | Prefer contain + investigate; avoid alarming copy without facts |

**Copy constraints (all channels):** no JWT, refresh tokens, passwords, or keystore material; no PII beyond the account email the user already owns; anonymous telemetry IDs only if a diagnostics packet is attached (SEC-C09).

Product owns final wording; Client engineer supplies factual blast radius (which builds/devices).

---

## 5. Security contact

| Field | Value |
|---|---|
| **Primary security contact** | `security@mi-iptv.example` *(replace with the real mailbox from Security §1 / org directory)* |
| **Escalation** | Incident lead → Security contact → Backend coordinator → Infra on-call |
| **Intake** | Email or org incident channel; subject prefix `[MiIPTV-Client]` |
| **What to include** | UTC detection time, client app + build SHA, platform (TV / Companion), **type** of secret (not the secret), where it appeared, contain steps already taken |
| **What never to include** | Raw tokens, passwords, keystore files, `.env` / `.properties` contents |

Until the real mailbox is substituted from Security §1, use the org’s existing security intake and update this table in the same PR that wires production contacts.

---

## 6. Quick checklist (copy into incident Notes)

- [ ] Incident lead + Security contact named  
- [ ] Leak path stopped / redacted  
- [ ] Local sessions cleared (secure storage)  
- [ ] Backend coordinator requested revocation / rotation  
- [ ] Hotfix SHA + tests green  
- [ ] SEC-002 Must IDs re-checked; release A6 Pass  
- [ ] User notification sent or deferred with Product rationale  
- [ ] Postmortem Note filed (no secrets in the Note)
