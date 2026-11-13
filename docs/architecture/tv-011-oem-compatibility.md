# TV-011 — OEM compatibility layer

**Refs:** NFR-009 · Depends on **TV-002** · Device matrix [QA-002](../qa/android_tv_device_matrix.md)  
**SDK floor:** API 34 ([ADR-002](./adr-002-tv-toolkit-sdk.md))

## Goal

Abstract manufacturer differences so Live TV / player code never branches on raw
`Build.MANUFACTURER` strings:

| Concern | Abstraction |
|---|---|
| Key mappings | [`TvRemoteKeyMapper`](../../lib/core/oem/tv_remote_key_mapper.dart) → [`TvRemoteAction`](../../lib/core/oem/tv_remote_action.dart) (CH+/CH− + OEM aliases) |
| Decoder capabilities | [`OemDecoderCapabilities`](../../lib/core/oem/oem_decoder_capabilities.dart) |
| Display modes | [`OemDisplayMode`](../../lib/core/oem/oem_display_mode.dart) |
| Manufacturer quirks | [`OemQuirk`](../../lib/core/oem/oem_quirk.dart) on [`OemCompatibilityProfile`](../../lib/core/oem/oem_compatibility_profile.dart) |

## Layout

| Piece | Location |
|---|---|
| Identity | [`OemDeviceIdentity`](../../lib/core/oem/oem_device_identity.dart) |
| Catalog | [`OemProfileCatalog`](../../lib/core/oem/oem_profile_catalog.dart) |
| Facade | [`OemCompatibility`](../../lib/core/oem/oem_compatibility.dart) |
| Reader port | [`OemDeviceIdentityReader`](../../lib/core/oem/oem_device_identity_reader.dart) |
| Android adapter | [`AndroidOemDeviceIdentityReader`](../../lib/core/oem/android_oem_device_identity_reader.dart) + [`OemCompatibilityPlugin`](../../android/app/src/main/kotlin/com/example/mi_iptv/oem/OemCompatibilityPlugin.kt) |
| DI | [`AppDependencies.oemCompatibility`](../../lib/app/di/app_dependencies.dart) |
| Live CH+/CH− | [`TvLiveTvPage.keyMapper`](../../lib/features/live_tv/presentation/tv/tv_live_tv_page.dart) via [`AppNavigator`](../../lib/app/navigation/app_navigator.dart) `tvLive` |

## OEM groups (QA-002)

| Manufacturer | Decoder / display | Notable quirks |
|---|---|---|
| Google (4K) | Mid 1080p | — |
| Google HD stick | Low-memory 1080p | `prefer1080pCeiling`, `conservativeAbr` |
| Sony | Mid 1080p | `pageKeysAsChannel`, `debounceDuplicateBack` |
| TCL / Hisense | Mid 1080p | `pageKeysAsChannel` |
| NVIDIA | Premium 4K + HDR10 | — |
| Unknown | Mid 1080p (safe) | `prefer1080pCeiling`, `conservativeAbr` |

## Packages

No new pubspec dependency. Host fingerprint uses a MethodChannel (same Option A pattern as Media3).

## Wiring

TV `bootstrap` reads Android identity → `OemCompatibility.forIdentity`. Companion and unit tests keep `OemCompatibility.unknown()`.
