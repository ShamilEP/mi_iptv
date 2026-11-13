import 'dart:async';

import '../entities/playback_session_signal.dart';
import '../repositories/media_player_controller.dart';
import '../repositories/playback_session_host.dart';

/// Owns playback session side-effects outside screens (TV-052).
///
/// While the engine is playing/buffering: request audio focus + keep screen on.
/// On audio-focus loss, app background, or HDMI disconnect: pause playback.
/// Does **not** auto-resume — the player UI / user must restart.
final class PlaybackSessionCoordinator {
  PlaybackSessionCoordinator({
    required this.player,
    required this.host,
  });

  final MediaPlayerController player;
  final PlaybackSessionHost host;

  StreamSubscription<MediaPlayerStatus>? _statusSub;
  StreamSubscription<PlaybackSessionSignal>? _signalSub;
  bool _active = false;
  bool _holdingResources = false;
  bool _disposed = false;

  bool get isHoldingResources => _holdingResources;

  /// Start listening to player status + platform signals.
  Future<void> start() async {
    if (_active || _disposed) return;
    _active = true;
    await host.start();
    _statusSub = player.status.listen(_onStatus);
    _signalSub = host.signals.listen(_onSignal);
  }

  /// Forward Flutter app lifecycle without importing Flutter in domain.
  void onAppBackgrounded() {
    if (!_active || _disposed) return;
    unawaited(_pauseForInterrupt());
  }

  void onAppForegrounded() {
    // Intentional no-op: do not auto-resume after background.
  }

  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    _active = false;
    await _statusSub?.cancel();
    await _signalSub?.cancel();
    _statusSub = null;
    _signalSub = null;
    await _releaseResources();
    await host.stop();
  }

  Future<void> _onStatus(MediaPlayerStatus status) async {
    if (_disposed) return;
    final needsHold = status.phase == MediaPlayerPhase.playing ||
        status.phase == MediaPlayerPhase.buffering;
    if (needsHold) {
      await _acquireResources();
    } else {
      await _releaseResources();
    }
  }

  Future<void> _onSignal(PlaybackSessionSignal signal) async {
    if (_disposed) return;
    switch (signal) {
      case PlaybackSessionSignal.audioFocusLost:
      case PlaybackSessionSignal.appBackgrounded:
      case PlaybackSessionSignal.hdmiDisconnected:
        await _pauseForInterrupt();
      case PlaybackSessionSignal.audioFocusGained:
      case PlaybackSessionSignal.appForegrounded:
      case PlaybackSessionSignal.hdmiConnected:
        break;
    }
  }

  Future<void> _pauseForInterrupt() async {
    try {
      await player.pause();
    } on Object {
      // Never throw into signal listeners.
    }
    await _releaseResources();
  }

  Future<void> _acquireResources() async {
    if (_holdingResources) return;
    _holdingResources = true;
    try {
      await host.requestAudioFocus();
      await host.setKeepScreenOn(true);
    } on Object {
      _holdingResources = false;
    }
  }

  Future<void> _releaseResources() async {
    if (!_holdingResources) return;
    _holdingResources = false;
    try {
      await host.abandonAudioFocus();
      await host.setKeepScreenOn(false);
    } on Object {
      // Best-effort release.
    }
  }
}
