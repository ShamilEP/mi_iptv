/// Settings category for the Android TV Settings shell (TV-080).
enum TvSettingsCategory { account, sources, network, language, playback }

/// One settings field with a visible current value.
class TvSettingsValue {
  const TvSettingsValue({required this.label, required this.value});

  final String label;
  final String value;
}

/// Snapshot of hierarchical Settings values shown in the shell.
class TvSettingsSnapshot {
  const TvSettingsSnapshot({
    required this.account,
    required this.sources,
    required this.network,
    required this.language,
    required this.playback,
  });

  final List<TvSettingsValue> account;
  final List<TvSettingsValue> sources;
  final List<TvSettingsValue> network;
  final List<TvSettingsValue> language;
  final List<TvSettingsValue> playback;

  List<TvSettingsValue> valuesFor(TvSettingsCategory category) {
    switch (category) {
      case TvSettingsCategory.account:
        return account;
      case TvSettingsCategory.sources:
        return sources;
      case TvSettingsCategory.network:
        return network;
      case TvSettingsCategory.language:
        return language;
      case TvSettingsCategory.playback:
        return playback;
    }
  }

  /// Compact summary shown on the category rail (first value).
  String summaryFor(TvSettingsCategory category) {
    final values = valuesFor(category);
    if (values.isEmpty) return '';
    return values.first.value;
  }
}
