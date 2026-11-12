import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/features/player/data/adapters/memory_media_player_controller.dart';
import 'package:mi_iptv/features/player/domain/repositories/media_player_controller.dart';

void main() {
  test('memory controller covers play pause seek stop phases', () async {
    final player = MemoryMediaPlayerController();
    addTearDown(player.dispose);

    final statuses = <MediaPlayerStatus>[];
    final sub = player.status.listen(statuses.add);
    addTearDown(sub.cancel);

    await player.play(Uri.parse('https://cdn.example/vod.mp4'));
    expect(player.currentStatus.phase, MediaPlayerPhase.playing);

    await player.pause();
    expect(player.currentStatus.phase, MediaPlayerPhase.paused);

    await player.seek(const Duration(seconds: 5));
    expect(player.currentStatus.position, const Duration(seconds: 5));

    await player.stop();
    expect(player.currentStatus.phase, MediaPlayerPhase.idle);
    expect(statuses, isNotEmpty);
  });
}
