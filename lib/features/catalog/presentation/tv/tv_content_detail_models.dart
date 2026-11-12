/// Presentation model for the TV content detail shell (DSN-034 / US-12).
///
/// Series season/episode navigation is deferred (PRD-013) — this model has no
/// season or episode fields.
class TvContentDetail {
  const TvContentDetail({
    required this.id,
    required this.title,
    required this.synopsis,
    required this.metadata,
    this.durationLabel,
    this.progress,
    this.isFavorite = false,
    this.related = const <TvRelatedContent>[],
  });

  final String id;
  final String title;
  final String synopsis;

  /// Short metadata chips (year, rating, genres, type, …).
  final List<String> metadata;

  /// Human-readable duration when the catalog provides it.
  final String? durationLabel;

  /// Playback fraction in \[0, 1\] when Continue Watching progress exists.
  final double? progress;

  final bool isFavorite;
  final List<TvRelatedContent> related;

  /// Resume is offered when progress is recoverable (≥15%, US-13).
  bool get showsResume {
    final value = progress;
    return value != null && value >= 0.15 && value < 1.0;
  }

  TvContentDetail copyWith({
    bool? isFavorite,
    double? progress,
    List<TvRelatedContent>? related,
  }) {
    return TvContentDetail(
      id: id,
      title: title,
      synopsis: synopsis,
      metadata: metadata,
      durationLabel: durationLabel,
      progress: progress ?? this.progress,
      isFavorite: isFavorite ?? this.isFavorite,
      related: related ?? this.related,
    );
  }
}

/// Related title shown in the detail Related rail (not series episodes).
class TvRelatedContent {
  const TvRelatedContent({
    required this.id,
    required this.title,
    this.subtitle,
  });

  final String id;
  final String title;
  final String? subtitle;
}
