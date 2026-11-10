# Mi IPTV — Client Defect Tracking (QA-005)

**Scope:** Flutter clients in this repository — Android TV / Google TV and Companion.  
**Companion doc:** [test_strategy.md](./test_strategy.md) (QA-001 phases & pyramid).  
**Release gate:** [release_checklist.md](./release_checklist.md) (go / no-go).  
**Authority:** Client execution of QA-005 / SRS §19 themes. External SRS wins on conflict; update this file when the spec changes.

---

## 1. Tracker of record

Use the **GitHub Issues** tracker on this client repo (or the org board that already points here) as the default defect system for client bugs.

- Label issues with the fields below (`severity`, `phase`, `client-surface`, …).
- Do **not** invent a second SaaS or rename Backend/Infra trackers from this repo.
- Product / Backend / Infra defects discovered while testing the client are filed in their owning trackers; link the client issue and mark the client task `Blocked` with a reason when needed.

---

## 2. Required issue fields

| Field | Required | Values / notes |
|---|---|---|
| Title | Yes | Short, user-visible symptom |
| Steps to reproduce | Yes | Numbered; include build (`main` SHA or `task/<ID>-…`) |
| Expected vs actual | Yes | |
| Environment | Yes | Local / CI / Staging / RC |
| Device class | Yes | `tv` \| `companion-android` \| `companion-ios` |
| Severity | Yes | Blocker / Critical / Major / Minor / Trivial (§3) |
| Priority | Triage | P0–P3 (schedule order; not the same as severity) |
| Phase | Yes | Sprint 0 / MVP / Release 1 |
| Feature | When known | `auth`, `home`, `live_tv`, `player`, … or `core` |
| Related task | When known | Tracker ID (e.g. `TV-033`) |
| Logs / screenshots | Preferred | **Scrub secrets** — no JWT, passwords, Xtream/M3U creds, refresh tokens; if a secret already leaked, follow [incident_response_runbook.md](../security/incident_response_runbook.md) (SEC-052) |

---

## 3. Severity definitions

Same taxonomy as QA-001 — impact on the user or security, not engineering effort.

| Severity | Definition | Client examples | Ship rule |
|---|---|---|---|
| **Blocker** | App unusable or unsafe; no workaround | Crash on launch; login impossible on staging; secrets in logs | Must fix before phase / release exit |
| **Critical** | Core MVP journey broken | Live tune always fails; send-to-TV never delivers; TV focus invisible | Must fix before phase / release exit |
| **Major** | Important feature impaired; workaround exists | Overlay timing wrong; one source type fails parse | Exit only with owner + target build |
| **Minor** | Limited polish / edge impact | Spacing drift; non-blocking copy | Does not hold exit |
| **Trivial** | Cosmetic nit | Typo in non-user string | Backlog |

---

## 4. Workflow

```
New → Triaged → In progress → In review → Done
         ↘ Blocked
         ↘ Won’t fix (human decision only)
```

| State | Who | Meaning |
|---|---|---|
| **New** | Reporter | Filed with required fields |
| **Triaged** | Human reviewer / QA owner | Severity + priority set; assignee or backlog |
| **In progress** | Owner | Fix on a `task/…` or defect branch |
| **In review** | Owner | Fix ready; analyze/tests green; linked PR/commit |
| **Done** | Human approval | Verified on the stated environment |
| **Blocked** | Owner | Waiting on Backend / Infra / Product / device |
| **Won’t fix** | Human only | Explicit accept risk or out of MVP |

Agents following `/execute-next-task` do **not** mark Product/Backend/Infra tracker rows Done, and do not invent product waivers.

---

## 5. Triage rules (client)

1. Repro on the named build before raising severity above **Minor**.
2. Security / secrets exposure → at least **Critical** (usually **Blocker**).
3. TV focus invisible or Companion accidentally playing video in MVP → **Critical**.
4. Duplicate: close as duplicate with link; keep the earliest actionable issue.
5. Every **Blocker** / **Critical** open at RC time is an automatic **no-go** on [release_checklist.md](./release_checklist.md).

---

## 6. Labels (suggested)

`severity:blocker` · `severity:critical` · `severity:major` · `severity:minor` · `severity:trivial`  
`phase:sprint-0` · `phase:mvp` · `phase:release-1`  
`surface:tv` · `surface:companion` · `surface:core`  
`type:defect`
