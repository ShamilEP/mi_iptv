import '../entities/playback_progress.dart';

/// Product constants for playback progress / Continue watching (FR-015 / US-15).
///
/// Not user-editable in MVP Settings.
abstract final class PlaybackProgressPolicy {
  /// Fixed client save interval while VOD plays.
  static const Duration saveInterval = Duration(seconds: 10);

  /// Minimum fraction of duration before a title enters Continue watching.
  static const double continueWatchingThreshold = 0.15;

  /// Whether [progress] qualifies for Continue watching / Resume.
  static bool qualifiesForContinueWatching(PlaybackProgress progress) {
    if (progress.forceReset) return false;
    final duration = progress.duration;
    if (duration == null || duration <= Duration.zero) return false;
    final fraction =
        progress.position.inMilliseconds / duration.inMilliseconds;
    return fraction >= continueWatchingThreshold && fraction < 1.0;
  }

  /// Position to start when the viewer chooses Play (always from the beginning).
  static Duration playFromStartPosition() => Duration.zero;

  /// Position to start when Resume is offered.
  static Duration resumePosition(PlaybackProgress progress) {
    if (!qualifiesForContinueWatching(progress)) return Duration.zero;
    return progress.position;
  }
}
