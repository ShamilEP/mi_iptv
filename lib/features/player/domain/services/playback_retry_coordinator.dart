import 'dart:async';

import '../entities/playback_error.dart';
import '../entities/playback_request.dart';
import '../repositories/media_player_controller.dart';
import 'playback_error_classifier.dart';
import 'playback_retry_policy.dart';

/// Owns automatic playback retry with preserved request + position context
/// (TV-054). Lifecycle belongs with the composition root — not player screens.
final class PlaybackRetryCoordinator {
  PlaybackRetryCoordinator({
    required this._player,
    this.policy = PlaybackRetryPolicy.defaults,
    Future<void> Function(Duration delay)? wait,
    String? Function(Uri uri)? hostOf,
  })  : _wait = wait ?? _defaultWait,
        _hostOf = hostOf ?? _defaultHostOf;

  final MediaPlayerController _player;
  final PlaybackRetryPolicy policy;
  final Future<void> Function(Duration delay) _wait;
  final String? Function(Uri uri) _hostOf;

  StreamSubscription<MediaPlayerStatus>? _subscription;
  PlaybackRequest? _activeRequest;
  int _failedAttempts = 0;
  bool _retryInFlight = false;
  bool _disposed = false;

  final _errors = StreamController<PlaybackError>.broadcast();

  /// Classified errors (including exhausted retries).
  Stream<PlaybackError> get errors => _errors.stream;

  Stream<MediaPlayerStatus> get status => _player.status;

  int get failedAttempts => _failedAttempts;

  PlaybackRequest? get activeRequest => _activeRequest;

  /// Starts playback and arms automatic retry for the session.
  Future<void> play(PlaybackRequest request) async {
    _ensureListening();
    _activeRequest = request;
    _failedAttempts = 0;
    _retryInFlight = false;
    await _player.play(request);
  }

  Future<void> pause() => _player.pause();

  Future<void> seek(Duration position) => _player.seek(position);

  Future<void> stop() async {
    _failedAttempts = 0;
    _retryInFlight = false;
    _activeRequest = null;
    await _player.stop();
  }

  Future<void> dispose() async {
    _disposed = true;
    await _subscription?.cancel();
    _subscription = null;
    await _errors.close();
  }

  void _ensureListening() {
    _subscription ??= _player.status.listen(_onStatus);
  }

  Future<void> _onStatus(MediaPlayerStatus status) async {
    if (_disposed) return;

    if (status.phase == MediaPlayerPhase.playing ||
        status.phase == MediaPlayerPhase.paused) {
      _failedAttempts = 0;
      _retryInFlight = false;
      return;
    }

    if (status.phase != MediaPlayerPhase.error) return;
    if (_retryInFlight) return;

    final request = _activeRequest;
    if (request == null) return;

    final error = PlaybackErrorClassifier.classify(
      status.message,
      position: status.position,
      streamHost: _hostOf(request.streamUri),
    );
    _failedAttempts += 1;

    if (!policy.canRetry(
      failedAttempts: _failedAttempts,
      error: error,
    )) {
      if (!_errors.isClosed) {
        _errors.add(error);
      }
      return;
    }

    _retryInFlight = true;
    final delay = policy.delayBeforeRetry(_failedAttempts);
    await _wait(delay);
    if (_disposed || _activeRequest != request) {
      _retryInFlight = false;
      return;
    }

    try {
      await _player.play(request);
      if (error.position > Duration.zero) {
        await _player.seek(error.position);
      }
    } finally {
      _retryInFlight = false;
    }
  }

  static Future<void> _defaultWait(Duration delay) =>
      Future<void>.delayed(delay);

  static String? _defaultHostOf(Uri uri) {
    if (uri.host.isEmpty) return null;
    return uri.host;
  }
}
