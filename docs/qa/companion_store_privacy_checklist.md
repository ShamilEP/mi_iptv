# Companion store privacy checklist (CMP-010)

**Refs:** SRS §1.3 · [cmp-010-companion-store-readiness.md](../architecture/cmp-010-companion-store-readiness.md) · SEC-022 / CMP-005 / CMP-006  
Use when filling **Google Play Data Safety** and **Apple App Privacy** for the Companion app.

## Instructions

1. Answer questionnaires from **client facts** below — do not invent collectors.
2. Privacy policy URL / legal entity: **Product (PRD-042)** — leave blank until provided.
3. Re-run this checklist when adding SDKs, telemetry, or permissions.

## Data inventory (MVP Companion)

| Category | Collected? | Linked to user? | On-device? | Purpose |
|---|---|---|---|---|
| Account credentials (email / session tokens) | Yes | Yes | Yes (Keystore / Keychain) | Login / refresh |
| Catalog / favorites / linked-TV cache | Yes | Yes | Yes (Drift) | Browse + offline |
| Pairing secrets | Yes | Yes | Yes (secure storage) | Link TV |
| Approximate location | No | — | — | — |
| Contacts / photos / mic / camera | No | — | — | — |
| Advertising ID / tracking | No | — | — | — |
| Crash / QoE diagnostics | No (MVP) | — | — | Enable later only with anonymous IDs (SEC-C09) |

## Sharing

| Third party | Data shared? |
|---|---|
| Ads / analytics SDKs | No in MVP |
| Backend API (Mi IPTV) | Yes — auth + catalog/sync over HTTPS only |

## Tracking (Apple ATT)

| Question | Answer |
|---|---|
| App tracks users across apps/sites? | **No** |
| `NSUserTrackingUsageDescription` required? | **No** |

## Encryption export (Apple)

| Question | Answer |
|---|---|
| Uses non-exempt encryption? | **No** — TLS via platform + Keychain/Keystore only (`ITSAppUsesNonExemptEncryption` = false) |

## Sign-off

| Field | Value |
|---|---|
| Build SHA | |
| Reviewer | |
| Date (UTC) | |
| Policy URL attached? | ☐ Product-provided / ☐ Blocked waiting on PRD-042 |
