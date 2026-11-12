/// Non-secret app setting persisted locally (TV-007).
///
/// Do not store tokens or source passwords in settings rows.
final class CachedSetting {
  const CachedSetting({
    required this.key,
    required this.value,
  });

  final String key;
  final String value;
}
