import '../repositories/media_player_controller.dart';

/// Viewer-facing playback wait state (TV-055 / FR-016).
///
/// Never carries raw Media3 codes — only simple status for spinner UX.
enum PlaybackStatusFeedback {
  /// No overlay — playing, paused, idle, ended, or terminal error UI owns the stage.
  none,

  /// Engine is filling buffers; show a spinner + plain "Loading…" copy.
  buffering,

  /// Auto-retry is in flight after a brief disconnect; show "Reconnecting…".
  reconnecting,
}

/// Maps engine phase + retry-in-flight into [PlaybackStatusFeedback].
///
/// Reconnecting wins over buffering so auto-retry feedback stays visible.
PlaybackStatusFeedback resolvePlaybackStatusFeedback({
  required MediaPlayerPhase phase,
  required bool isReconnecting,
}) {
  if (isReconnecting) return PlaybackStatusFeedback.reconnecting;
  if (phase == MediaPlayerPhase.buffering) {
    return PlaybackStatusFeedback.buffering;
  }
  return PlaybackStatusFeedback.none;
}

/// Plain-language labels for [PlaybackStatusFeedback] (no technical jargon).
abstract final class PlaybackStatusFeedbackCopy {
  static const String buffering = 'Loading…';
  static const String reconnecting = 'Reconnecting…';

  static String labelFor(PlaybackStatusFeedback feedback) {
    return switch (feedback) {
      PlaybackStatusFeedback.none => '',
      PlaybackStatusFeedback.buffering => buffering,
      PlaybackStatusFeedback.reconnecting => reconnecting,
    };
  }
}
