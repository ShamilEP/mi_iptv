/// Locally cached hybrid source descriptor (TV-007).
///
/// **No secrets** — never persist Xtream/M3U passwords, tokens, or auth headers
/// here (SEC-C07). Credentials stay in secure storage when needed.
final class CachedSource {
  const CachedSource({
    required this.sourceId,
    required this.kind,
    required this.displayName,
    this.baseUrl,
  });

  final String sourceId;

  /// proprietary | xtream | m3u
  final String kind;
  final String displayName;

  /// Optional base host URL without credentials.
  final Uri? baseUrl;
}
