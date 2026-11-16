import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/features/player/data/adapters/memory_media_player_controller.dart';
import 'package:mi_iptv/features/player/domain/entities/playback_audio_state.dart';
import 'package:mi_iptv/features/player/domain/entities/playback_request.dart';
import 'package:mi_iptv/features/player/presentation/tv/vod_transport_session.dart';

void main() {
  test('TV-056 VOD transport mute survives replay and pause', () async {
    final player = MemoryMediaPlayerController();
    addTearDown(player.dispose);
    final transport = VodTransportSession(player: player);
    addTearDown(transport.dispose);

    final request = PlaybackRequest(
      streamUri: Uri.parse('https://cdn.example/vod.mp4'),
    );
    await transport.start(request);
    await transport.toggleMute();
    expect(transport.muted, isTrue);
    expect(player.audioState.muted, isTrue);

    await transport.togglePlayPause(); // pause
    await transport.togglePlayPause(); // play again

    expect(transport.muted, isTrue);
    expect(player.audioState.muted, isTrue);
    expect(player.audioState.volume, PlaybackAudioState.defaultVolume);
  });
}
