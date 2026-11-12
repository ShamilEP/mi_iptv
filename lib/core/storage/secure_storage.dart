/// Platform-backed key/value vault (Android Keystore / iOS Keychain).
///
/// Domain and presentation depend on this port only — never on a plugin.
/// Values are secrets: do not log keys' payloads (SEC-C02 / SEC-C06).
abstract interface class SecureStorage {
  Future<void> write({required String key, required String value});

  Future<String?> read({required String key});

  Future<void> delete({required String key});

  Future<void> clear();
}
