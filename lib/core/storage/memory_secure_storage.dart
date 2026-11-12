import 'secure_storage.dart';

/// Process-local [SecureStorage] for unit tests and pre-plugin wiring.
///
/// Not durable and not Keystore/Keychain — production uses
/// [FlutterSecureStorageAdapter] (CMP-005 / TV-008).
final class MemorySecureStorage implements SecureStorage {
  final Map<String, String> _values = <String, String>{};

  @override
  Future<void> write({required String key, required String value}) async {
    _values[key] = value;
  }

  @override
  Future<String?> read({required String key}) async => _values[key];

  @override
  Future<void> delete({required String key}) async {
    _values.remove(key);
  }

  @override
  Future<void> clear() async {
    _values.clear();
  }
}
