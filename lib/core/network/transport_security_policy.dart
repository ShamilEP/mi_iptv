/// Transport / cleartext policy (SEC-023 / Security §3.1).
///
/// - **Backend / API:** HTTPS (TLS) only.
/// - **User IPTV media:** `http` or `https` allowed; cleartext media triggers
///   a user-visible warning (HTTPS streams preferred).
///
/// Platform cleartext (Android NSC) exists so Media3 can fetch plain-http
/// streams; this policy keeps API and non-media surfaces on TLS.
abstract final class TransportSecurityPolicy {
  /// User-facing copy when a media URL uses cleartext HTTP.
  static const String cleartextMediaWarning =
      'This stream uses an unencrypted HTTP link. Prefer HTTPS when your '
      'provider offers it — your connection to the Mi IPTV service stays '
      'encrypted either way.';

  /// True when [uri] may be used as a Mi IPTV backend / API base or path host.
  static bool isBackendUriAllowed(Uri uri) {
    if (!uri.hasScheme || uri.host.isEmpty) return false;
    return uri.scheme.toLowerCase() == 'https';
  }

  /// True when [uri] may be handed to the media player (user IPTV / catalog).
  ///
  /// Allows `http` and `https` only. Rejects empty hosts and other schemes.
  static bool isMediaStreamUriAllowed(Uri uri) {
    if (!uri.hasScheme || uri.host.isEmpty) return false;
    final scheme = uri.scheme.toLowerCase();
    return scheme == 'https' || scheme == 'http';
  }

  /// True when playing [uri] should show [cleartextMediaWarning].
  static bool requiresCleartextMediaWarning(Uri uri) {
    if (!isMediaStreamUriAllowed(uri)) return false;
    return uri.scheme.toLowerCase() == 'http';
  }

  /// Parses [raw] and returns a media URI when allowed; otherwise null.
  static Uri? tryParseMediaStreamUri(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return null;
    final uri = Uri.tryParse(trimmed);
    if (uri == null) return null;
    if (!isMediaStreamUriAllowed(uri)) return null;
    return uri;
  }

  /// Parses [raw] and returns a backend URI when allowed; otherwise null.
  static Uri? tryParseBackendUri(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return null;
    final uri = Uri.tryParse(trimmed);
    if (uri == null) return null;
    if (!isBackendUriAllowed(uri)) return null;
    return uri;
  }
}
