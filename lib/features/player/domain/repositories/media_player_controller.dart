import '../entities/playback_audio_state.dart';
import '../entities/playback_request.dart';

/// Playback port. Media3/ExoPlayer (or approved engine) implements this in data/adapters.
abstract interface class MediaPlayerController {
  /// Starts playback for [request] (HLS / DASH / progressive TS|MP4).
  ///
  /// Must **not** reset [audioState] — mute/volume survive play / zap / retry
  /// (TV-056 / NFR-QOE-06).
  Future<void> play(PlaybackRequest request);

  Future<void> pause();
  Future<void> seek(Duration position);
  Future<void> stop();

  /// Applies user-requested loudness. Call only from explicit UI / remote.
  Future<void> setAudioState(PlaybackAudioState state);

  /// Last user-applied mute + volume (engine may report effective gain of 0).
  PlaybackAudioState get audioState;

  Stream<MediaPlayerStatus> get status;
}

enum MediaPlayerPhase { idle, buffering, playing, paused, ended, error }

final class MediaPlayerStatus {
  const MediaPlayerStatus({
    required this.phase,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.message,
  });

  final MediaPlayerPhase phase;
  final Duration position;
  final Duration duration;
  final String? message;
}
