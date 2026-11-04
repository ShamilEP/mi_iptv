/// Playback port. Media3/ExoPlayer (or approved engine) implements this in data/adapters.
abstract interface class MediaPlayerController {
  Future<void> play(Uri streamUri);
  Future<void> pause();
  Future<void> seek(Duration position);
  Future<void> stop();
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
