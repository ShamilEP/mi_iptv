import 'dart:async';

import '../../domain/repositories/media_player_controller.dart';

/// In-memory [MediaPlayerController] for unit tests and non-TV surfaces
/// (Companion has no MVP video playback).
final class MemoryMediaPlayerController implements MediaPlayerController {
  MemoryMediaPlayerController() {
    _controller.add(_status);
  }

  final _controller = StreamController<MediaPlayerStatus>.broadcast();
  MediaPlayerStatus _status = const MediaPlayerStatus(phase: MediaPlayerPhase.idle);

  MediaPlayerStatus get currentStatus => _status;

  @override
  Stream<MediaPlayerStatus> get status => _controller.stream;

  @override
  Future<void> play(Uri streamUri) async {
    _emit(
      MediaPlayerStatus(
        phase: MediaPlayerPhase.playing,
        position: Duration.zero,
        duration: const Duration(minutes: 1),
        message: streamUri.scheme.isEmpty ? 'invalid_uri' : null,
      ),
    );
  }

  @override
  Future<void> pause() async {
    _emit(
      MediaPlayerStatus(
        phase: MediaPlayerPhase.paused,
        position: _status.position,
        duration: _status.duration,
      ),
    );
  }

  @override
  Future<void> seek(Duration position) async {
    final clamped = position.isNegative ? Duration.zero : position;
    _emit(
      MediaPlayerStatus(
        phase: _status.phase == MediaPlayerPhase.idle
            ? MediaPlayerPhase.paused
            : _status.phase,
        position: clamped,
        duration: _status.duration,
      ),
    );
  }

  @override
  Future<void> stop() async {
    _emit(const MediaPlayerStatus(phase: MediaPlayerPhase.idle));
  }

  void dispose() {
    unawaited(_controller.close());
  }

  void _emit(MediaPlayerStatus next) {
    _status = next;
    if (!_controller.isClosed) {
      _controller.add(next);
    }
  }
}
