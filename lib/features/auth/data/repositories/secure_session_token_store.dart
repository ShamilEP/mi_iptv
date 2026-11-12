import '../../../../core/storage/secure_storage.dart';
import '../../../../core/storage/secure_storage_keys.dart';
import '../../domain/entities/session_tokens.dart';
import '../../domain/repositories/session_token_store.dart';

/// Session tokens in [SecureStorage] (SEC-C06). Never logs token values.
final class SecureSessionTokenStore implements SessionTokenStore {
  SecureSessionTokenStore(this._storage);

  final SecureStorage _storage;

  @override
  Future<void> save(SessionTokens tokens) async {
    await _storage.write(
      key: SecureStorageKeys.accessToken,
      value: tokens.accessToken,
    );
    await _storage.write(
      key: SecureStorageKeys.refreshToken,
      value: tokens.refreshToken,
    );
  }

  @override
  Future<SessionTokens?> read() async {
    final access = await _storage.read(key: SecureStorageKeys.accessToken);
    final refresh = await _storage.read(key: SecureStorageKeys.refreshToken);
    if (access == null || refresh == null) return null;
    if (access.isEmpty && refresh.isEmpty) return null;
    return SessionTokens(accessToken: access, refreshToken: refresh);
  }

  @override
  Future<void> clear() async {
    await _storage.delete(key: SecureStorageKeys.accessToken);
    await _storage.delete(key: SecureStorageKeys.refreshToken);
  }
}
