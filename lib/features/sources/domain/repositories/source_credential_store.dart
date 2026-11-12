import '../entities/source_credentials.dart';

/// Secure vault for hybrid-source credentials (TV-008).
///
/// Implementations must use Keystore / Keychain — never plain storage.
abstract interface class SourceCredentialStore {
  Future<void> save(SourceCredentials credentials);

  Future<SourceCredentials?> read(String sourceId);

  Future<void> delete(String sourceId);
}
