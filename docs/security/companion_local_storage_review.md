# Companion local storage review (SEC-022)

**Refs:** Security §3.2 · Depends on **CMP-005**  
**Clients:** Companion Android + iOS (`companion` flavor / Runner)  
**Related:** [cmp-005-secure-storage.md](../architecture/cmp-005-secure-storage.md), [android_tv_local_storage_review.md](./android_tv_local_storage_review.md) (SEC-021), [client_security_checklist.md](./client_security_checklist.md)

## Verdict

**Pass** for MVP Companion local-storage controls after locking iOS Keychain accessibility and secret-surface hygiene.

| Control | Finding | Evidence |
|---|---|---|
| Android Keystore | Shared [`FlutterSecureStorageAdapter`](../../lib/core/storage/flutter_secure_storage_adapter.dart): AES-GCM + RSA-OAEP Keystore wrap; Auto Backup off + prefs exclusions (SEC-021) apply to Companion Android APK | Adapter + main `AndroidManifest.xml` |
| iOS Keychain accessibility | `KeychainAccessibility.first_unlock_this_device`, `synchronizable: false` (no iCloud Keychain sync / no cross-device migrate) | Adapter `IOSOptions` |
| Logs | [`SecretRedactor`](../../lib/core/logging/secret_redactor.dart) / `AppLog`; [`SessionTokens`](../../lib/features/auth/domain/entities/session_tokens.dart) and [`PairingSecureData`](../../lib/features/devices/domain/entities/pairing_secure_data.dart) `toString()` redacted | Unit + contract tests |
| Screenshots | Secrets are not rendered in Companion UI (password fields use `obscureText`; tokens/pairing secrets never shown as plain text) | Auth / parental PIN shells; review |
| Clipboard | No `Clipboard` writes in `lib/` — pairing secrets and tokens are never copied to the system clipboard | Repo grep + contract test |

## Stores in scope

| Store | Keys | Backend |
|---|---|---|
| Session tokens | `SecureSessionTokenStore` | Secure storage |
| TV pairing | `SecurePairingStore` | Secure storage |

## Out of scope

- TV-only backup review already Done → **SEC-021**
- Network cleartext / NSC → **SEC-023**
- Reading `*.properties` / signing secrets (harness ban)

## Manual follow-up (optional)

On a physical Companion phone: confirm Keychain items are not in iCloud Keychain for the app, and that Logcat / Console never prints access or pairing secrets.
