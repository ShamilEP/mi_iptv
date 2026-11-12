/// Xtream / M3U / proprietary source secrets (TV-008 / SEC-C07).
///
/// Persist only via [SourceCredentialStore] → Keystore-backed vault.
/// Never put these in SQLite, prefs, logs, or UI.
final class SourceCredentials {
  const SourceCredentials({
    required this.sourceId,
    this.username,
    this.password,
    this.token,
  });

  final String sourceId;
  final String? username;
  final String? password;
  final String? token;

  bool get isEmpty =>
      (username == null || username!.isEmpty) &&
      (password == null || password!.isEmpty) &&
      (token == null || token!.isEmpty);

  /// Redacted — safe for accidental logging / debug dumps.
  @override
  String toString() => 'SourceCredentials(sourceId: $sourceId, ***)';
}
