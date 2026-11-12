# CMP-005 — Companion secure storage

**Status:** Implemented (platform adapter + ports).  
**Refs:** Security §3.2; SEC-C06; tracker CMP-005. Related: TV-008 (reuse adapter).

## Goal

Persist **session tokens** and **TV pairing data** in Android Keystore–backed storage and iOS Keychain — never in plain prefs, logs, or UI.

## Layout

| Piece | Location |
|---|---|
| Port | [`SecureStorage`](../../lib/core/storage/secure_storage.dart) |
| Key names | [`SecureStorageKeys`](../../lib/core/storage/secure_storage_keys.dart) |
| Platform adapter | [`FlutterSecureStorageAdapter`](../../lib/core/storage/flutter_secure_storage_adapter.dart) (`flutter_secure_storage` 11.x) |
| Test vault | [`MemorySecureStorage`](../../lib/core/storage/memory_secure_storage.dart) |
| Session store | [`SecureSessionTokenStore`](../../lib/features/auth/data/repositories/secure_session_token_store.dart) |
| Pairing store | [`SecurePairingStore`](../../lib/features/devices/data/repositories/secure_pairing_store.dart) |
| Device wiring | [`bootstrap`](../../lib/app/bootstrap.dart) → `FlutterSecureStorageAdapter` |
| DI | [`AppDependencies`](../../lib/app/di/app_dependencies.dart) |

Widgets / use cases call `SessionTokenStore` / `PairingSecureStore` only — never the plugin.

## Platform notes

- **Android:** default `AndroidOptions` (AES-GCM + Keystore key wrap). minSdk stays Flutter default (≥24) / TV 34.
- **iOS:** default `IOSOptions` (Keychain).
- **Logout:** clear via `sessionTokenStore.clear()` / `pairingSecureStore.clear()` / `secureStorage.clear()` — never log values.

## Package

| Package | Version | Role |
|---|---|---|
| `flutter_secure_storage` | ^11 (approved) | Keystore / Keychain KV behind adapter |
