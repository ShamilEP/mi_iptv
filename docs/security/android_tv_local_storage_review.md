# Android TV local storage review (SEC-021)

**Refs:** Security §3.2 · Depends on **TV-008**  
**Client:** TV flavor (`android/app/src/tv`) + shared `main` application chrome  
**Related:** [tv-008-secure-storage.md](../architecture/tv-008-secure-storage.md), [client_security_checklist.md](./client_security_checklist.md) (SEC-C02 / SEC-C06 / SEC-C07)

## Verdict

**Pass** for MVP local-storage controls on Android TV, with backup hardening applied in this task.

| Control | Finding | Evidence |
|---|---|---|
| Keystore / ESP successor | Session tokens and source credentials go through [`FlutterSecureStorageAdapter`](../../lib/core/storage/flutter_secure_storage_adapter.dart): AES-GCM + RSA-OAEP in **Android Keystore** (`flutter_secure_storage` 11.x; replaces deprecated EncryptedSharedPreferences) | Adapter + [tv-008](../architecture/tv-008-secure-storage.md) |
| Logcat redaction | [`SecretRedactor`](../../lib/core/logging/secret_redactor.dart) + [`AppLog`](../../lib/core/logging/app_log.dart); token/credential `toString()` redacted | `test/core/logging/secret_redactor_test.dart` |
| Backup / data extraction | `android:allowBackup="false"` on application; [`backup_rules.xml`](../../android/app/src/main/res/xml/backup_rules.xml) + [`data_extraction_rules.xml`](../../android/app/src/main/res/xml/data_extraction_rules.xml) exclude `FlutterSecureStorage` shared prefs | Manifest + XML contract tests |

## Non-secret local cache

TV-007 SQLite / Drift media cache stays **secret-free** (`CachedSource` has no passwords). Credentials remain only in `SourceCredentialStore` → secure storage.

## Out of scope

- Companion-specific review → **SEC-022**
- Network cleartext / NSC → **SEC-023**
- Reading `*.properties` / keystore password files (harness ban)

## Manual follow-up (optional)

On a TV API 34 device: confirm Auto Backup is disabled for the package and that `adb backup` does not yield usable session material.
