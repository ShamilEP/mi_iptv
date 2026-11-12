/// In-memory session token pair. Persist only via [SecureStorage] (SEC-C06).
///
/// Never log [accessToken] or [refreshToken].
final class SessionTokens {
  const SessionTokens({
    required this.accessToken,
    required this.refreshToken,
  });

  final String accessToken;
  final String refreshToken;

  bool get isEmpty => accessToken.isEmpty && refreshToken.isEmpty;
}
