import 'dart:convert';

import '../../../../core/storage/secure_storage.dart';
import '../../../../core/storage/secure_storage_keys.dart';
import '../../domain/entities/source_credentials.dart';
import '../../domain/repositories/source_credential_store.dart';

/// Source credentials in [SecureStorage] (TV-008 / SEC-C07).
///
/// Never logs username, password, or token values.
final class SecureSourceCredentialStore implements SourceCredentialStore {
  SecureSourceCredentialStore(this._storage);

  final SecureStorage _storage;

  @override
  Future<void> save(SourceCredentials credentials) async {
    final payload = <String, String?>{
      'username': credentials.username,
      'password': credentials.password,
      'token': credentials.token,
    };
    await _storage.write(
      key: SecureStorageKeys.sourceCredentials(credentials.sourceId),
      value: jsonEncode(payload),
    );
  }

  @override
  Future<SourceCredentials?> read(String sourceId) async {
    final raw = await _storage.read(
      key: SecureStorageKeys.sourceCredentials(sourceId),
    );
    if (raw == null || raw.isEmpty) return null;

    final map = jsonDecode(raw) as Map<String, dynamic>;
    final credentials = SourceCredentials(
      sourceId: sourceId,
      username: map['username'] as String?,
      password: map['password'] as String?,
      token: map['token'] as String?,
    );
    if (credentials.isEmpty) return null;
    return credentials;
  }

  @override
  Future<void> delete(String sourceId) async {
    await _storage.delete(
      key: SecureStorageKeys.sourceCredentials(sourceId),
    );
  }
}
