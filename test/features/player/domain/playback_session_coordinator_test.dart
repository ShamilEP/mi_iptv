import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/features/player/data/adapters/memory_media_player_controller.dart';
import 'package:mi_iptv/features/player/data/adapters/memory_playback_session_host.dart';
import 'package:mi_iptv/features/player/domain/entities/playback_request.dart';
import 'package:mi_iptv/features/player/domain/entities/playback_session_signal.dart';
import 'package:mi_iptv/features/player/domain/repositories/media_player_controller.dart';
import 'package:mi_iptv/features/player/domain/services/playback_session_coordinator.dart';

void main() {
  group('TV-052 playback session lifecycle', () {
    test('acquires audio focus and keep-screen-on while playing', () async {
      final player = MemoryMediaPlayerController();
      final host = MemoryPlaybackSessionHost();
      final coordinator = PlaybackSessionCoordinator(player: player, host: host);
      addTearDown(() async {
        await coordinator.dispose();
        await host.dispose();
      });

      await coordinator.start();
      expect(host.started, isTrue);

      await player.play(
        PlaybackRequest(streamUri: Uri.parse('https://cdn.example/a.m3u8')),
      );
      await _flush();

      expect(host.audioFocusHeld, isTrue);
      expect(host.keepScreenOn, isTrue);
      expect(coordinator.isHoldingResources, isTrue);

      await player.pause();
      await _flush();
      expect(host.audioFocusHeld, isFalse);
      expect(host.keepScreenOn, isFalse);
    });

    test('pauses on audio focus loss and HDMI disconnect', () async {
      final player = _TrackingPlayer();
      final host = MemoryPlaybackSessionHost();
      final coordinator = PlaybackSessionCoordinator(player: player, host: host);
      addTearDown(() async {
        await coordinator.dispose();
        await host.dispose();
      });

      await coordinator.start();
      player.emit(MediaPlayerPhase.playing);
      await _flush();
      expect(host.keepScreenOn, isTrue);

      host.emit(PlaybackSessionSignal.audioFocusLost);
      await _flush();
      expect(player.pauseCalls, 1);
      expect(host.keepScreenOn, isFalse);

      player.emit(MediaPlayerPhase.playing);
      await _flush();
      host.emit(PlaybackSessionSignal.hdmiDisconnected);
      await _flush();
      expect(player.pauseCalls, 2);
    });

    test('app background pauses without auto-resume on foreground', () async {
      final player = _TrackingPlayer();
      final host = MemoryPlaybackSessionHost();
      final coordinator = PlaybackSessionCoordinator(player: player, host: host);
      addTearDown(() async {
        await coordinator.dispose();
        await host.dispose();
      });

      await coordinator.start();
      player.emit(MediaPlayerPhase.playing);
      await _flush();

      coordinator.onAppBackgrounded();
      await _flush();
      expect(player.pauseCalls, 1);

      coordinator.onAppForegrounded();
      await _flush();
      expect(player.pauseCalls, 1);
      expect(player.playCalls, 0);
    });
  });
}

Future<void> _flush() async {
  await Future<void>.delayed(Duration.zero);
  await Future<void>.delayed(Duration.zero);
}

final class _TrackingPlayer implements MediaPlayerController {
  final _controller = StreamController<MediaPlayerStatus>.broadcast();
  int pauseCalls = 0;
  int playCalls = 0;

  @override
  Stream<MediaPlayerStatus> get status => _controller.stream;

  @override
  Future<void> play(PlaybackRequest request) async {
    playCalls += 1;
  }

  @override
  Future<void> pause() async {
    pauseCalls += 1;
    emit(MediaPlayerPhase.paused);
  }

  @override
  Future<void> seek(Duration position) async {}

  @override
  Future<void> stop() async {}

  void emit(MediaPlayerPhase phase) {
    _controller.add(MediaPlayerStatus(phase: phase));
  }
}
