import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../domain/entities/playback_audio_state.dart';
import '../../domain/entities/playback_request.dart';
import '../../domain/repositories/media_player_controller.dart';
import '../../domain/services/accelerated_seek.dart';

/// Presentation-side VOD transport state (TV-062 / TV-056).
///
/// Optional [player] syncs timeline from Media3. Without it, local demo state
/// still supports seek / play-pause for widget tests. Mute/volume change only
/// via [toggleMute] / [volumeDown] / [volumeUp] — never on play/pause/seek.
final class VodTransportSession extends ChangeNotifier {
  VodTransportSession({
    this._player,
    this._activeRequest,
    Duration initialPosition = const Duration(minutes: 12, seconds: 40),
    Duration initialDuration = const Duration(hours: 1, minutes: 45),
    bool initiallyPlaying = true,
    PlaybackAudioState initialAudio = const PlaybackAudioState(),
  })  : _position = initialPosition,
        _duration = initialDuration,
        _playing = initiallyPlaying,
        _audio = initialAudio {
    final media = _player;
    if (media != null) {
      _audio = media.audioState;
      _subscription = media.status.listen(_onStatus);
    }
  }

  final MediaPlayerController? _player;
  PlaybackRequest? _activeRequest;
  StreamSubscription<MediaPlayerStatus>? _subscription;

  Duration _position;
  Duration _duration;
  bool _playing;
  PlaybackAudioState _audio;
  MediaPlayerPhase _phase = MediaPlayerPhase.idle;
  String? _subtitleCue;

  Timer? _accelTimer;
  DateTime? _accelStartedAt;
  bool _accelForward = true;

  Duration get position => _position;
  Duration get duration => _duration;
  bool get playing => _playing;
  bool get muted => _audio.muted;
  double get volume => _audio.volume;
  PlaybackAudioState get audioState => _audio;
  MediaPlayerPhase get phase => _phase;

  /// Live cue text from Media3 for DSN-021 captions (TV-057).
  String? get subtitleCue => _subtitleCue;
  PlaybackRequest? get activeRequest => _activeRequest;

  double get progress {
    if (_duration <= Duration.zero) return 0;
    final ratio = _position.inMilliseconds / _duration.inMilliseconds;
    return ratio.clamp(0.0, 1.0);
  }

  Future<void> start(PlaybackRequest request) async {
    _activeRequest = request;
    final player = _player;
    if (player == null) {
      _playing = true;
      notifyListeners();
      return;
    }
    await player.play(request);
    // Re-assert user audio after play (engine may rebuild) — TV-056.
    await player.setAudioState(_audio);
  }

  Future<void> togglePlayPause() async {
    if (_playing) {
      await _player?.pause();
      _playing = false;
      notifyListeners();
      return;
    }
    final request = _activeRequest;
    final player = _player;
    if (player != null && request != null) {
      await player.play(request);
      if (_position > Duration.zero) {
        await player.seek(_position);
      }
      await player.setAudioState(_audio);
    }
    _playing = true;
    notifyListeners();
  }

  Future<void> seekBy(Duration delta) async {
    await seekTo(_clamp(_position + delta));
  }

  Future<void> seekTo(Duration position) async {
    _position = _clamp(position);
    notifyListeners();
    await _player?.seek(_position);
  }

  Future<void> toggleMute() async {
    _audio = _audio.toggleMute();
    notifyListeners();
    await _player?.setAudioState(_audio);
  }

  Future<void> volumeDown() async {
    _audio = _audio.volumeDown();
    notifyListeners();
    await _player?.setAudioState(_audio);
  }

  Future<void> volumeUp() async {
    _audio = _audio.volumeUp();
    notifyListeners();
    await _player?.setAudioState(_audio);
  }

  void startAcceleratedSeek({required bool forward}) {
    if (_accelTimer != null && _accelForward == forward) return;
    stopAcceleratedSeek();
    _accelForward = forward;
    _accelStartedAt = DateTime.now();
    unawaited(
      seekBy(forward ? AcceleratedSeek.tapStep : -AcceleratedSeek.tapStep),
    );
    _accelTimer = Timer.periodic(const Duration(milliseconds: 350), (_) {
      final started = _accelStartedAt;
      if (started == null) return;
      final elapsed = DateTime.now().difference(started);
      final step = AcceleratedSeek.stepForHoldElapsed(elapsed);
      unawaited(seekBy(forward ? step : -step));
    });
  }

  void stopAcceleratedSeek() {
    _accelTimer?.cancel();
    _accelTimer = null;
    _accelStartedAt = null;
  }

  void _onStatus(MediaPlayerStatus status) {
    _position = status.position;
    _phase = status.phase;
    _subtitleCue = status.subtitleCue;
    if (status.duration > Duration.zero) {
      _duration = status.duration;
    }
    if (status.phase == MediaPlayerPhase.playing) {
      _playing = true;
    } else if (status.phase == MediaPlayerPhase.paused ||
        status.phase == MediaPlayerPhase.ended) {
      _playing = false;
    }
    // Intentionally do not sync mute/volume from status — user intent only.
    notifyListeners();
  }

  Duration _clamp(Duration value) {
    if (value.isNegative) return Duration.zero;
    if (_duration > Duration.zero && value > _duration) return _duration;
    return value;
  }

  @override
  void dispose() {
    stopAcceleratedSeek();
    unawaited(_subscription?.cancel());
    super.dispose();
  }
}
