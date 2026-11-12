import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/features/player/domain/entities/playback_error.dart';
import 'package:mi_iptv/features/player/domain/entities/playback_request.dart';
import 'package:mi_iptv/features/player/domain/repositories/media_player_controller.dart';
import 'package:mi_iptv/features/player/domain/services/playback_retry_coordinator.dart';
import 'package:mi_iptv/features/player/domain/services/playback_retry_policy.dart';

void main() {
  test('retries network errors with preserved request then stops at cap', () async {
    final player = _FakePlayer();
    final waits = <Duration>[];
    final coordinator = PlaybackRetryCoordinator(
      player: player,
      policy: const PlaybackRetryPolicy(
        maxAttempts: 2,
        initialDelay: Duration(milliseconds: 10),
        multiplier: 2,
        maxDelay: Duration(seconds: 1),
      ),
      wait: (delay) async {
        waits.add(delay);
      },
    );
    addTearDown(coordinator.dispose);

    final exhausted = <PlaybackError>[];
    final sub = coordinator.errors.listen(exhausted.add);
    addTearDown(sub.cancel);

    final request = PlaybackRequest(
      streamUri: Uri.parse('https://cdn.example/live.m3u8'),
    );
    await coordinator.play(request);
    expect(player.playCount, 1);

    player.emitError('ERROR_CODE_IO_NETWORK_CONNECTION_TIMEOUT', position: Duration.zero);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);
    expect(player.playCount, 2);
    expect(waits, isNotEmpty);
    expect(coordinator.activeRequest, same(request));

    player.emitError('ERROR_CODE_IO_NETWORK_CONNECTION_TIMEOUT');
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);
    expect(player.playCount, 3);

    player.emitError('ERROR_CODE_IO_NETWORK_CONNECTION_TIMEOUT');
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);
    expect(player.playCount, 3);
    expect(exhausted, isNotEmpty);
    expect(exhausted.last.kind, PlaybackErrorKind.network);
  });

  test('does not retry decoder errors', () async {
    final player = _FakePlayer();
    final coordinator = PlaybackRetryCoordinator(
      player: player,
      wait: (_) async {},
    );
    addTearDown(coordinator.dispose);

    final exhausted = <PlaybackError>[];
    final sub = coordinator.errors.listen(exhausted.add);
    addTearDown(sub.cancel);

    await coordinator.play(
      PlaybackRequest(streamUri: Uri.parse('https://cdn.example/a.mp4')),
    );
    player.emitError('ERROR_CODE_DECODER_INIT_FAILED');
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    expect(player.playCount, 1);
    expect(exhausted.single.kind, PlaybackErrorKind.decoder);
  });
}

final class _FakePlayer implements MediaPlayerController {
  final _controller = StreamController<MediaPlayerStatus>.broadcast();
  int playCount = 0;

  @override
  Stream<MediaPlayerStatus> get status => _controller.stream;

  @override
  Future<void> play(PlaybackRequest request) async {
    playCount += 1;
  }

  @override
  Future<void> pause() async {}

  @override
  Future<void> seek(Duration position) async {}

  @override
  Future<void> stop() async {}

  void emitError(String code, {Duration position = Duration.zero}) {
    _controller.add(
      MediaPlayerStatus(
        phase: MediaPlayerPhase.error,
        position: position,
        message: code,
      ),
    );
  }
}
