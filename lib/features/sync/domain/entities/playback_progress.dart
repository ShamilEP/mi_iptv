import 'sync_metadata.dart';

/// Cross-device VOD / resume position (shared domain — TV-005 / ADR-001).
final class PlaybackProgress {
  const PlaybackProgress({
    required this.contentId,
    required this.position,
    required this.sync,
    this.duration,
    this.forceReset = false,
  });

  final String contentId;
  final Duration position;
  final Duration? duration;
  final SyncMetadata sync;

  /// When true, this side wins over a higher remote position in the short window.
  final bool forceReset;

  PlaybackProgress copyWith({
    Duration? position,
    Duration? duration,
    SyncMetadata? sync,
    bool? forceReset,
  }) {
    return PlaybackProgress(
      contentId: contentId,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      sync: sync ?? this.sync,
      forceReset: forceReset ?? this.forceReset,
    );
  }
}
