import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/features/player/data/adapters/memory_media_player_controller.dart';
import 'package:mi_iptv/features/player/domain/entities/playback_audio_state.dart';
import 'package:mi_iptv/features/player/domain/entities/playback_request.dart';
import 'package:mi_iptv/features/player/domain/entities/stream_protocol.dart';
import 'package:mi_iptv/features/player/domain/repositories/media_player_controller.dart';

void main() {
  test('memory controller covers play pause seek stop phases', () async {
    final player = MemoryMediaPlayerController();
    addTearDown(player.dispose);

    final statuses = <MediaPlayerStatus>[];
    final sub = player.status.listen(statuses.add);
    addTearDown(sub.cancel);

    await player.play(
      PlaybackRequest(streamUri: Uri.parse('https://cdn.example/vod.mp4')),
    );
    expect(player.currentStatus.phase, MediaPlayerPhase.playing);
    expect(player.lastProtocol, StreamProtocol.progressiveMp4);

    await player.pause();
    expect(player.currentStatus.phase, MediaPlayerPhase.paused);

    await player.seek(const Duration(seconds: 5));
    expect(player.currentStatus.position, const Duration(seconds: 5));

    await player.stop();
    expect(player.currentStatus.phase, MediaPlayerPhase.idle);
    expect(statuses, isNotEmpty);
  });

  test('TV-056 memory play preserves mute without user setAudioState', () async {
    final player = MemoryMediaPlayerController();
    addTearDown(player.dispose);

    await player.setAudioState(
      const PlaybackAudioState(muted: true, volume: 0.2),
    );
    await player.play(
      PlaybackRequest(streamUri: Uri.parse('https://cdn.example/a.mp4')),
    );
    expect(player.audioState.muted, isTrue);
    expect(player.audioState.volume, 0.2);
  });
}
