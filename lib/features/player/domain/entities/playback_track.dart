/// Selectable audio or text track from a stream (TV-057 / FR-017 MVP).
enum PlaybackTrackKind { audio, subtitle }

/// Catalog / engine track descriptor. Manual picker UX is Release 1 (DSN-064).
final class PlaybackTrack {
  const PlaybackTrack({
    required this.id,
    required this.kind,
    required this.label,
    this.languageCode = '',
    this.isDefault = false,
    this.isOff = false,
  });

  final String id;
  final PlaybackTrackKind kind;
  final String label;
  final String languageCode;

  /// Source-marked default (Media3 `SELECTION_FLAG_DEFAULT` or catalog hint).
  final bool isDefault;

  /// Synthetic “Off” row for subtitles — never selected as a source default.
  final bool isOff;
}

/// Resolved MVP defaults after [DefaultTrackPolicy] (TV-057).
final class DefaultTrackSelection {
  const DefaultTrackSelection({
    required this.audioTrackId,
    required this.subtitleTrackId,
  });

  final String audioTrackId;

  /// Subtitle track id, or an Off sentinel when the source has no default text.
  final String subtitleTrackId;
}
