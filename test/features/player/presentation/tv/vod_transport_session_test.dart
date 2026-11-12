import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/features/player/domain/services/accelerated_seek.dart';
import 'package:mi_iptv/features/player/presentation/tv/vod_playback_clock.dart';
import 'package:mi_iptv/features/player/presentation/tv/vod_transport_session.dart';

void main() {
  test('local session seeks by tap step and formats clocks', () async {
    final session = VodTransportSession(
      initialPosition: const Duration(minutes: 1),
      initialDuration: const Duration(minutes: 10),
      initiallyPlaying: true,
    );
    addTearDown(session.dispose);

    expect(formatVodClock(session.position), '01:00');
    await session.seekBy(AcceleratedSeek.tapStep);
    expect(session.position, const Duration(minutes: 1, seconds: 10));

    await session.togglePlayPause();
    expect(session.playing, isFalse);

    session.volumeDown();
    expect(session.volume, lessThan(0.8));
  });
}
