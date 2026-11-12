import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'secure_storage.dart';

/// Keystore / Keychain-backed [SecureStorage] via `flutter_secure_storage`
/// (CMP-005 / TV-008).
///
/// **Android:** AES-GCM data cipher with RSA-OAEP key wrap in Android Keystore
/// (flutter_secure_storage 11.x — successor to EncryptedSharedPreferences).
/// **iOS:** Keychain via default [IOSOptions].
///
/// Only this adapter (and tests' [MemorySecureStorage]) may touch the plugin.
/// Never log [write]/[read] payloads (SEC-C02 / SEC-C06 / NFR-005).
final class FlutterSecureStorageAdapter implements SecureStorage {
  FlutterSecureStorageAdapter({FlutterSecureStorage? plugin})
      : _plugin = plugin ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(
                keyCipherAlgorithm:
                    KeyCipherAlgorithm.RSA_ECB_OAEPwithSHA_256andMGF1Padding,
                storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
              ),
              iOptions: IOSOptions(),
            );

  final FlutterSecureStorage _plugin;

  @override
  Future<void> write({required String key, required String value}) {
    return _plugin.write(key: key, value: value);
  }

  @override
  Future<String?> read({required String key}) {
    return _plugin.read(key: key);
  }

  @override
  Future<void> delete({required String key}) {
    return _plugin.delete(key: key);
  }

  @override
  Future<void> clear() {
    return _plugin.deleteAll();
  }
}
