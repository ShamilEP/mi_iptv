import 'dart:async';

import '../../domain/entities/playback_audio_state.dart';
import '../../domain/entities/playback_request.dart';
import '../../domain/entities/stream_protocol.dart';
import '../../domain/repositories/media_player_controller.dart';
import '../../domain/services/stream_format_sniffer.dart';

/// In-memory [MediaPlayerController] for unit tests and non-TV surfaces
/// (Companion has no MVP video playback).
final class MemoryMediaPlayerController implements MediaPlayerController {
  MemoryMediaPlayerController() {
    _controller.add(_status);
  }

  final _controller = StreamController<MediaPlayerStatus>.broadcast();
  MediaPlayerStatus _status = const MediaPlayerStatus(phase: MediaPlayerPhase.idle);
  PlaybackAudioState _audioState = const PlaybackAudioState();
  PlaybackRequest? _lastRequest;
  StreamProtocol? _lastProtocol;

  MediaPlayerStatus get currentStatus => _status;

  PlaybackRequest? get lastRequest => _lastRequest;

  StreamProtocol? get lastProtocol => _lastProtocol;

  @override
  PlaybackAudioState get audioState => _audioState;

  @override
  Stream<MediaPlayerStatus> get status => _controller.stream;

  @override
  Future<void> play(PlaybackRequest request) async {
    _lastRequest = request;
    _lastProtocol = StreamFormatSniffer.sniff(
      request.streamUri,
      protocolHint: request.protocolHint,
    );
    // TV-056: play must not reset mute / volume.
    // TV-057: preserve active cue text across play.
    _emit(
      MediaPlayerStatus(
        phase: MediaPlayerPhase.playing,
        position: Duration.zero,
        duration: const Duration(minutes: 1),
        message: request.streamUri.scheme.isEmpty ? 'invalid_uri' : null,
        subtitleCue: _status.subtitleCue,
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
        subtitleCue: _status.subtitleCue,
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
        subtitleCue: _status.subtitleCue,
      ),
    );
  }

  @override
  Future<void> stop() async {
    _emit(const MediaPlayerStatus(phase: MediaPlayerPhase.idle));
  }

  @override
  Future<void> setAudioState(PlaybackAudioState state) async {
    _audioState = state;
  }

  /// Test helper — emit an arbitrary phase (e.g. buffering) without jargon.
  void emitPhase(
    MediaPlayerPhase phase, {
    Duration? position,
    Duration? duration,
    String? message,
    String? subtitleCue,
  }) {
    _emit(
      MediaPlayerStatus(
        phase: phase,
        position: position ?? _status.position,
        duration: duration ?? _status.duration,
        message: message,
        subtitleCue: subtitleCue ?? _status.subtitleCue,
      ),
    );
  }

  /// Test helper — emit a DSN-021 caption cue while playing.
  void emitSubtitleCue(String? cue) {
    _emit(
      MediaPlayerStatus(
        phase: _status.phase,
        position: _status.position,
        duration: _status.duration,
        message: _status.message,
        subtitleCue: cue,
      ),
    );
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
