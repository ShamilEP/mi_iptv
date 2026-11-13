/// Boundary sanitize for remote artwork URLs (TV-012 / client security).
///
/// Accepts **HTTPS only**. Strips credentials from userInfo. Returns null when
/// the string is missing, opaque, or unsafe.
abstract final class ArtworkUri {
  static Uri? tryParse(String? raw) {
    if (raw == null) return null;
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return null;

    final uri = Uri.tryParse(trimmed);
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) return null;
    if (uri.scheme.toLowerCase() != 'https') return null;

    if (uri.userInfo.isEmpty) return uri;
    return uri.replace(userInfo: '');
  }
}
