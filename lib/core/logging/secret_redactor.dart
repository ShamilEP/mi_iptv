/// Redacts common secret shapes before anything reaches Logcat (TV-008 / NFR-005).
///
/// Use [redact] on every debug / diagnostic string that might include tokens,
/// passwords, or bearer values. Prefer not logging secrets at all.
abstract final class SecretRedactor {
  static final List<RegExp> _patterns = <RegExp>[
    // Bearer before generic Authorization so the token value is redacted.
    RegExp(
      r'(Bearer\s+)([A-Za-z0-9\-._~+/]+=*)',
      caseSensitive: false,
    ),
    RegExp(
      r'((?:access|refresh)[_-]?token\s*[:=]\s*)([^\s,;}"'']+)',
      caseSensitive: false,
    ),
    RegExp(
      r'((?:password|passwd|pwd|secret|token)\s*[:=]\s*)([^\s,;}"'']+)',
      caseSensitive: false,
    ),
    RegExp(
      r'(://[^/\s:@]+:)([^@/\s]+)(@)',
    ),
  ];

  /// Returns [input] with secret-looking spans replaced by `***`.
  static String redact(String input) {
    var result = input;
    for (final pattern in _patterns) {
      result = result.replaceAllMapped(pattern, (match) {
        if (match.groupCount >= 3) {
          return '${match[1]}***${match[3]}';
        }
        return '${match[1]}***';
      });
    }
    return result;
  }
}
