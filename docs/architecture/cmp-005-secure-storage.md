# CMP-005 — Companion secure storage

**Status:** Blocked on package approval (Keystore / Keychain plugin).  
**Refs:** Security §3.2; SEC-C06; tracker CMP-005 (Companion). Related: TV-008.

## Goal

Persist **session tokens** and **TV pairing data** in Android Keystore–backed storage and iOS Keychain — never in plain prefs, logs, or UI.

## Landed in this task (plugin-free)

| Piece | Location |
|---|---|
| Port | [`SecureStorage`](../../lib/core/storage/secure_storage.dart) |
| Key names | [`SecureStorageKeys`](../../lib/core/storage/secure_storage_keys.dart) |
| Test / interim vault | [`MemorySecureStorage`](../../lib/core/storage/memory_secure_storage.dart) |
| Session store | [`SecureSessionTokenStore`](../../lib/features/auth/data/repositories/secure_session_token_store.dart) |
| Pairing store | [`SecurePairingStore`](../../lib/features/devices/data/repositories/secure_pairing_store.dart) |
| DI | [`AppDependencies`](../../lib/app/di/app_dependencies.dart) (`secureStorage`, `sessionTokenStore`, `pairingSecureStore`) |

Widgets and use cases must call `SessionTokenStore` / `PairingSecureStore` only — never a plugin.

## Package proposal (needs explicit approval)

| Need | Candidate | Why | Alternatives |
|---|---|---|---|
| Keystore + Keychain KV | **`flutter_secure_storage`** | Mature EncryptedSharedPreferences / Keystore (Android) + Keychain (iOS); fits adapter pattern | Custom MethodChannel; `biometric_storage` (overkill for MVP tokens) |

After approval: add dependency → implement `FlutterSecureStorageAdapter implements SecureStorage` under `lib/core/storage/` or `data/adapters/` → default it in `AppDependencies` for device builds; keep `MemorySecureStorage` for unit tests.

## DoD remaining

- [ ] User approves `flutter_secure_storage` (or chosen alternative)
- [ ] Platform adapter wired for Companion (and reusable by TV-008)
- [ ] Device/smoke note that tokens survive process death and clear on logout path
