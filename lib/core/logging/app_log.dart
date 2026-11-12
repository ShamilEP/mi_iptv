import 'package:flutter/foundation.dart';

import 'secret_redactor.dart';

/// Debug logging that always redacts secrets before Logcat (TV-008).
///
/// No-op in release/profile unless [force] is true (still redacted).
abstract final class AppLog {
  static void d(String message, {bool force = false}) {
    if (!force && !kDebugMode) return;
    debugPrint(SecretRedactor.redact(message));
  }
}
