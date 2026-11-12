import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'secure_storage.dart';

/// Keystore / Keychain-backed [SecureStorage] via `flutter_secure_storage` (CMP-005).
///
/// Only this adapter (and tests' [MemorySecureStorage]) may touch the plugin.
/// Never log [write]/[read] payloads (SEC-C02 / SEC-C06).
final class FlutterSecureStorageAdapter implements SecureStorage {
  FlutterSecureStorageAdapter({FlutterSecureStorage? plugin})
      : _plugin = plugin ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(),
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
