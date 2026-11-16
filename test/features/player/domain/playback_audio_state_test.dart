import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/features/player/data/adapters/memory_media_player_controller.dart';
import 'package:mi_iptv/features/player/domain/entities/playback_audio_state.dart';
import 'package:mi_iptv/features/player/domain/entities/playback_request.dart';
import 'package:mi_iptv/features/player/domain/services/playback_session_coordinator.dart';
import 'package:mi_iptv/features/player/data/adapters/memory_playback_session_host.dart';
import 'package:mi_iptv/features/player/domain/entities/playback_session_signal.dart';

void main() {
  group('TV-056 playback audio state', () {
    test('mute preserves volume level for unmute', () {
      const state = PlaybackAudioState(volume: 0.6);
      final muted = state.toggleMute();
      expect(muted.muted, isTrue);
      expect(muted.volume, 0.6);
      expect(muted.effectiveVolume, 0);
      expect(muted.toggleMute().muted, isFalse);
      expect(muted.toggleMute().volume, 0.6);
    });

    test('volume steps only via explicit up/down', () {
      var state = const PlaybackAudioState();
      state = state.volumeDown();
      expect(state.volume, closeTo(0.7, 0.001));
      state = state.volumeUp();
      expect(state.volume, closeTo(0.8, 0.001));
      expect(state.muted, isFalse);
    });

    test('play / pause / seek / focus loss never reset mute or volume', () async {
      final player = MemoryMediaPlayerController();
      addTearDown(player.dispose);
      final host = MemoryPlaybackSessionHost();
      final coordinator = PlaybackSessionCoordinator(player: player, host: host);
      addTearDown(coordinator.dispose);
      await coordinator.start();

      const muted = PlaybackAudioState(muted: true, volume: 0.35);
      await player.setAudioState(muted);

      final request = PlaybackRequest(
        streamUri: Uri.parse('https://cdn.example/live.m3u8'),
      );
      await player.play(request);
      await player.pause();
      await player.seek(const Duration(seconds: 3));
      await player.play(request);

      host.emit(PlaybackSessionSignal.audioFocusLost);
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);

      expect(player.audioState.muted, isTrue);
      expect(player.audioState.volume, 0.35);
    });
  });
}
