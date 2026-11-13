# CMP-010 — Companion store readiness

**Refs:** SRS §1.3 · Depends on **DSN-005**, **PRD-042** (listing identity / policy URL — Product)  
**Related:** [companion_store_privacy_checklist.md](../qa/companion_store_privacy_checklist.md), [store_review_account.md](../qa/store_review_account.md), [release_checklist.md](../qa/release_checklist.md)

## Goal

Prepare the Companion client for App Store / Play review: **icons**, **permissions**, **privacy labels** (questionnaire facts), and a **demo / review account** playbook — without committing secrets or inventing Product decisions.

## Layout

| Piece | Location |
|---|---|
| Inventory | [`CompanionStoreReadiness`](../../lib/core/store/companion_store_readiness.dart) |
| Icons (DSN-005) | `assets/brand/app_icon_512.png`, `assets/brand/adaptive/*`, Android `@mipmap/ic_launcher` |
| Android name | `android/app/src/companion/res/values/strings.xml` → `Mi IPTV Companion` |
| Android network | `android.permission.INTERNET` in **main** manifest (release + debug) |
| iOS display + export | `ios/Runner/Info.plist` display name; `ITSAppUsesNonExemptEncryption` |
| Privacy checklist | [companion_store_privacy_checklist.md](../qa/companion_store_privacy_checklist.md) |
| Review account template | [store_review_account.md](../qa/store_review_account.md) |

## Icons

Regenerate Android launcher rasters from DSN-005:

```bash
python tool/export_brand_assets.py
```

Store listing 512 master: `assets/brand/app_icon_512.png`.  
iOS `AppIcon.appiconset` must be refreshed from that master before submission (manual / future export step). Companion mark: `mark_companion.svg` / `lockup_companion.png`.

## Permissions

| Platform | Declared for Companion MVP |
|---|---|
| Android | `INTERNET` only |
| iOS | No custom `NS*UsageDescription` / no ATT |

Camera, mic, location, Bluetooth, and tracking are **not** used.

## Privacy labels

Fill Play Data Safety and Apple App Privacy from [`CompanionStoreReadiness.privacyDataCategories`](../../lib/core/store/companion_store_readiness.dart) and the QA checklist.  
**Privacy policy URL** and final listing copy remain **PRD-042 / Product** (do not invent).

## Demo account

Credentials are provisioned by Backend/ops on staging TLS — see [store_review_account.md](../qa/store_review_account.md). Reviewer steps are non-secret in `CompanionStoreReadiness.reviewerNotes`.

## Explicitly out of scope (Blocked on Product / Infra)

- Final `applicationId` / bundle ID (still `com.example.*` placeholder)
- Production signing / Play App Signing / App Store Connect certs
- Live privacy policy URL
- Real reviewer passwords in git
