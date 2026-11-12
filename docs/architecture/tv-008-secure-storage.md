# TV-008 — Secure storage (TV)

**Status:** Implemented.  
**Refs:** NFR-005; Security §3.2; tracker TV-008. Related: CMP-005 (shared adapter), TV-007 (non-secret SQLite cache).

## Goal

Persist **session tokens** and **source credentials** in Android Keystore–backed storage; keep secrets out of Logcat.

## Layout

| Piece | Location |
|---|---|
| Port | [`SecureStorage`](../../lib/core/storage/secure_storage.dart) |
| Platform adapter | [`FlutterSecureStorageAdapter`](../../lib/core/storage/flutter_secure_storage_adapter.dart) |
| Session tokens | [`SecureSessionTokenStore`](../../lib/features/auth/data/repositories/secure_session_token_store.dart) |
| Source credentials | [`SecureSourceCredentialStore`](../../lib/features/sources/data/repositories/secure_source_credential_store.dart) |
| Log redaction | [`SecretRedactor`](../../lib/core/logging/secret_redactor.dart) / [`AppLog`](../../lib/core/logging/app_log.dart) |
| Device wiring | [`bootstrap`](../../lib/app/bootstrap.dart) → `FlutterSecureStorageAdapter` |

`CachedSource` (TV-007) stays secret-free; passwords/tokens live only in `SourceCredentialStore`.

## Android Keystore vs EncryptedSharedPreferences

Spec cites EncryptedSharedPreferences / Keystore. `flutter_secure_storage` **11.x** no longer uses Jetpack EncryptedSharedPreferences (deprecated). Default path:

- Data: AES-GCM
- Key wrap: RSA-OAEP in **Android Keystore**

This meets the security intent of the ESP + Keystore requirement.

## Logcat (NFR-005)

- Never log raw tokens, passwords, or bearer headers.
- `SessionTokens` / `SourceCredentials` `toString()` are redacted.
- Route debug output through `AppLog.d` (applies `SecretRedactor`).

## Backup / data extraction (SEC-021)

- Application `android:allowBackup="false"`.
- [`backup_rules.xml`](../../android/app/src/main/res/xml/backup_rules.xml) and
  [`data_extraction_rules.xml`](../../android/app/src/main/res/xml/data_extraction_rules.xml)
  exclude `FlutterSecureStorage` shared preferences.
- Review write-up: [android_tv_local_storage_review.md](../security/android_tv_local_storage_review.md).
