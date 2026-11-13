# Store compliance (QA-052)

**Refs:** SRS §1.3 · Depends on **PRD-042** (listing identity / policy URL — Product) · **TV-003**, **CMP-010**, **QA-002**  
**Inventory:** [`StoreCompliance`](../../lib/core/store/store_compliance.dart)  
**Executable suite:** [`test/core/store/store_compliance_test.dart`](../../test/core/store/store_compliance_test.dart)  
**Companion deep-dive:** [cmp-010-companion-store-readiness.md](../architecture/cmp-010-companion-store-readiness.md), [companion_store_privacy_checklist.md](./companion_store_privacy_checklist.md)  
**TV packaging:** [tv-003-android-tv-launcher.md](../architecture/tv-003-android-tv-launcher.md)

## Goal

Gate **Google Play Android TV / TV quality** guidelines and **App Store / Play Companion review readiness** with client-verifiable checks — without inventing Product listing copy, policy URLs, or package IDs.

## Play TV quality

| Check | Automated? | Evidence |
|---|---|---|
| Leanback launcher, `touchscreen` optional, leanback feature | Yes | `android/app/src/tv/AndroidManifest.xml` |
| Banner **320×180** | Yes | `tv_banner.png` + brand master |
| D-pad focus visible (Cloud ring + Signal glow) | Yes | QA-025 / TV-121, FocusStyles, TV-123 |
| Overscan inset for actionable chrome | Yes | `AppOverscan` |
| 2–3 m legibility / contrast | Yes | QA-037 / TV-123 |
| No touch-only primary TV journeys | Manual | TV shells + focus maps |
| Device smoke on QA-002 tier M (+ L) | Manual | [android_tv_device_matrix.md](./android_tv_device_matrix.md) |

## App Store / Play (Companion)

| Check | Automated? | Evidence |
|---|---|---|
| Icons (DSN-005) | Yes | `CompanionStoreReadiness.iconAssetPaths` |
| Permissions INTERNET-only / no ATT | Yes | CMP-010 |
| Privacy questionnaire facts | Yes | Privacy checklist + categories |
| No Companion video playback (MVP) | Yes | Reviewer notes |
| Review account playbook (no secrets in git) | Yes | [store_review_account.md](./store_review_account.md) |
| Privacy policy URL + final IDs | **Product** | **PRD-042** — leave blank / Blocked until provided |

## Sign-off

| Field | Value |
|---|---|
| Build SHA | |
| TV APK flavor | `tvProd` / `tvDev` |
| Companion targets | Android `companionProd` + iOS |
| Reviewer | |
| Date (UTC) | |
| PRD-042 policy URL + IDs | ☐ Attached / ☐ Blocked waiting on Product |

## Out of scope

- Production signing / Play App Signing / App Store Connect certificates (Infra)
- Fire OS / Smart TV storefronts
- Invented store listing screenshots or marketing copy
