import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/images/image_cache_controller.dart';
import 'package:mi_iptv/core/images/image_pipeline.dart';
import 'package:mi_iptv/core/images/image_pipeline_config.dart';
import 'package:mi_iptv/features/player/data/adapters/memory_media_player_controller.dart';
import 'package:mi_iptv/features/player/data/adapters/memory_playback_session_host.dart';
import 'package:mi_iptv/features/player/domain/entities/playback_error.dart';
import 'package:mi_iptv/features/player/domain/entities/playback_request.dart';
import 'package:mi_iptv/features/player/domain/entities/playback_session_signal.dart';
import 'package:mi_iptv/features/player/domain/repositories/media_player_controller.dart';
import 'package:mi_iptv/features/player/domain/services/playback_retry_coordinator.dart';
import 'package:mi_iptv/features/player/domain/services/playback_retry_policy.dart';
import 'package:mi_iptv/features/player/domain/services/playback_session_coordinator.dart';

import 'live_playback_soak_harness.dart';

Future<void> _flush() async {
  await Future<void>.delayed(Duration.zero);
  await Future<void>.delayed(Duration.zero);
}

void main() {
  group('QA-042 live playback soak', () {
    test('lab duration and accelerated mapping stay locked to 24h', () {
      expect(LivePlaybackSoak.labDuration, const Duration(hours: 24));
      expect(
        LivePlaybackSoak.acceleratedCycles,
        LivePlaybackSoak.labDuration.inMinutes,
      );
      expect(
        LivePlaybackSoak.zapCycles,
        lessThan(LivePlaybackSoak.acceleratedCycles),
      );
      expect(LivePlaybackSoak.liveUris, everyElement(startsWith('https://')));
    });

    test(
      'continuous live hold releases session resources after accelerated soak',
      () async {
        final player = MemoryMediaPlayerController();
        final host = MemoryPlaybackSessionHost();
        final coordinator = PlaybackSessionCoordinator(
          player: player,
          host: host,
        );

        await coordinator.start();
        await player.play(LivePlaybackSoak.liveRequest(0));
        await _flush();
        expect(coordinator.isHoldingResources, isTrue);
        expect(host.audioFocusHeld, isTrue);
        expect(host.keepScreenOn, isTrue);

        final interruptEvery =
            LivePlaybackSoak.acceleratedCycles ~/ LivePlaybackSoak.interruptSamples;

        for (var i = 0; i < LivePlaybackSoak.acceleratedCycles; i++) {
          await player.seek(Duration(seconds: i % 3600));
          if (i > 0 && i % interruptEvery == 0) {
            coordinator.onAppBackgrounded();
            await _flush();
            expect(player.currentStatus.phase, MediaPlayerPhase.paused);
            expect(coordinator.isHoldingResources, isFalse);
            await player.play(LivePlaybackSoak.liveRequest(0));
            await _flush();
            expect(coordinator.isHoldingResources, isTrue);
          }
        }

        await coordinator.dispose();
        await host.dispose();
        player.dispose();

        expect(coordinator.isHoldingResources, isFalse);
        expect(host.audioFocusHeld, isFalse);
        expect(host.keepScreenOn, isFalse);
        expect(host.started, isFalse);
      },
    );

    test('channel zap churn does not leave wake-lock or focus held', () async {
      final player = MemoryMediaPlayerController();
      final host = MemoryPlaybackSessionHost();
      final coordinator = PlaybackSessionCoordinator(
        player: player,
        host: host,
      );

      await coordinator.start();

      for (var i = 0; i < LivePlaybackSoak.zapCycles; i++) {
        await player.play(LivePlaybackSoak.liveRequest(i));
        await _flush();
        expect(coordinator.isHoldingResources, isTrue);
        await player.stop();
        await _flush();
        expect(coordinator.isHoldingResources, isFalse);
        expect(host.audioFocusHeld, isFalse);
        expect(host.keepScreenOn, isFalse);
      }

      await player.play(LivePlaybackSoak.liveRequest(1));
      await _flush();
      host.emit(PlaybackSessionSignal.hdmiDisconnected);
      await _flush();
      expect(player.currentStatus.phase, MediaPlayerPhase.paused);
      expect(coordinator.isHoldingResources, isFalse);

      await coordinator.dispose();
      await host.dispose();
      player.dispose();
    });

    test('retry stays capped under repeated live stream failures', () async {
      const policy = PlaybackRetryPolicy(
        maxAttempts: 3,
        initialDelay: Duration.zero,
        maxDelay: Duration.zero,
      );
      final player = _FailingLivePlayer();
      var waits = 0;
      final retry = PlaybackRetryCoordinator(
        player: player,
        policy: policy,
        wait: (_) async {
          waits += 1;
        },
      );

      final exhausted = <PlaybackError>[];
      final sub = retry.errors.listen(exhausted.add);

      // Several independent live tunes, each exhausting the retry ceiling.
      for (var session = 0; session < 10; session++) {
        waits = 0;
        exhausted.clear();
        player.playCount = 0;
        await retry.play(LivePlaybackSoak.liveRequest(session));
        expect(player.playCount, 1);

        for (var failure = 0; failure < 5; failure++) {
          player.emitNetworkError();
          await _flush();
        }

        // Initial play + maxAttempts retries, then stop.
        expect(player.playCount, 1 + policy.maxAttempts);
        expect(waits, policy.maxAttempts);
        expect(exhausted, isNotEmpty);
        expect(exhausted.last.kind, PlaybackErrorKind.network);
      }

      await sub.cancel();
      await retry.dispose();
      player.dispose();
    });

    test(
      'low-memory image cache stays within NFR-003 budget under soak pressure',
      () {
        final cache = MemoryImageCacheController();
        final pipeline = ImagePipeline(
          config: LivePlaybackSoak.lowMemoryBudget,
          cache: cache,
        );

        expect(cache.maximumSize, ImagePipelineConfig.tvLowMemory.maximumSize);
        expect(
          cache.maximumSizeBytes,
          ImagePipelineConfig.tvLowMemory.maximumSizeBytes,
        );

        for (var i = 0; i < LivePlaybackSoak.zapCycles; i++) {
          cache.currentSize = cache.currentSize + 5;
          cache.currentSizeBytes = cache.currentSizeBytes + (512 * 1024);

          if (cache.currentSize > cache.maximumSize ||
              cache.currentSizeBytes > cache.maximumSizeBytes) {
            pipeline.releaseOffscreenImages();
          }

          expect(cache.currentSize, lessThanOrEqualTo(cache.maximumSize));
          expect(
            cache.currentSizeBytes,
            lessThanOrEqualTo(cache.maximumSizeBytes),
          );
        }

        expect(cache.clearLiveCalls, greaterThan(0));
        pipeline.clearAll();
        expect(cache.currentSize, 0);
        expect(cache.currentSizeBytes, 0);
      },
    );
  });
}

/// Emits retryable live network errors for soak retry-cap coverage.
final class _FailingLivePlayer implements MediaPlayerController {
  final _controller = StreamController<MediaPlayerStatus>.broadcast();
  int playCount = 0;

  @override
  Stream<MediaPlayerStatus> get status => _controller.stream;

  @override
  Future<void> play(PlaybackRequest request) async {
    // Do not emit playing — a success status would reset failedAttempts and
    // defeat the soak's retry-cap assertion (matches TV-054 fakes).
    playCount += 1;
  }

  @override
  Future<void> pause() async {}

  @override
  Future<void> seek(Duration position) async {}

  @override
  Future<void> stop() async {
    _controller.add(const MediaPlayerStatus(phase: MediaPlayerPhase.idle));
  }

  void emitNetworkError() {
    _controller.add(
      const MediaPlayerStatus(
        phase: MediaPlayerPhase.error,
        message: 'ERROR_CODE_IO_NETWORK_CONNECTION_TIMEOUT',
      ),
    );
  }

  void dispose() {
    unawaited(_controller.close());
  }
}
