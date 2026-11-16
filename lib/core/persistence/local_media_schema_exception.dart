/// Thrown when the local media SQLite schema is missing or unreadable (TV-015).
///
/// Callers should surface [message] — do not wipe durable data silently.
final class LocalMediaSchemaException implements Exception {
  const LocalMediaSchemaException(this.message);

  final String message;

  @override
  String toString() => 'LocalMediaSchemaException: $message';
}
