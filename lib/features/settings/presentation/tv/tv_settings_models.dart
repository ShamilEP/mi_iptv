/// Settings category for hierarchical TV Settings (DSN-038).
enum TvSettingsCategory { playback, account, sources, diagnostics }

/// One settings field with a visible current value.
class TvSettingsValue {
  const TvSettingsValue({required this.label, required this.value});

  final String label;
  final String value;
}

/// Catalog / IPTV source row with priority order.
class TvSettingsSource {
  const TvSettingsSource({
    required this.id,
    required this.name,
    required this.kind,
    required this.priority,
  });

  final String id;
  final String name;
  final String kind;
  final int priority;

  TvSettingsSource copyWith({int? priority}) {
    return TvSettingsSource(
      id: id,
      name: name,
      kind: kind,
      priority: priority ?? this.priority,
    );
  }
}

/// Diagnostics snapshot shown in Settings.
class TvSettingsDiagnostics {
  const TvSettingsDiagnostics({
    required this.network,
    required this.source,
    required this.latency,
    required this.buffer,
    required this.version,
  });

  final String network;
  final String source;
  final String latency;
  final String buffer;
  final String version;
}
