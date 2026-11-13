import '../../../auth/domain/entities/session_tokens.dart';

/// Lightweight stored-JWT inspection (TV-020).
///
/// Does **not** decode claims or log token material — only shape / presence.
abstract final class SessionJwtInspector {
  /// True when [accessToken] has three non-empty JWT segments.
  static bool hasUsableAccessToken(SessionTokens? tokens) {
    if (tokens == null) return false;
    final access = tokens.accessToken.trim();
    if (access.isEmpty) return false;
    final parts = access.split('.');
    return parts.length == 3 && parts.every((part) => part.isNotEmpty);
  }
}
