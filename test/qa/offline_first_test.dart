import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/network/connectivity_probe.dart';
import 'package:mi_iptv/core/network/connectivity_status.dart';
import 'package:mi_iptv/core/network/memory_connectivity_monitor.dart';
import 'package:mi_iptv/core/network/offline_mode_policy.dart';
import 'package:mi_iptv/core/network/polling_connectivity_monitor.dart';
import 'package:mi_iptv/core/persistence/memory_local_media_store.dart';
import 'package:mi_iptv/core/widgets/offline_banner.dart';
import 'package:mi_iptv/features/catalog/domain/entities/content_item.dart';
import 'package:mi_iptv/features/home/presentation/tv/tv_home_connectivity_binder.dart';
import 'package:mi_iptv/features/home/presentation/tv/tv_home_page.dart';
import 'package:mi_iptv/features/player/domain/entities/playback_error.dart';
import 'package:mi_iptv/features/player/domain/entities/playback_request.dart';
import 'package:mi_iptv/features/player/domain/repositories/media_player_controller.dart';
import 'package:mi_iptv/features/player/domain/services/playback_retry_coordinator.dart';
import 'package:mi_iptv/features/player/domain/services/playback_retry_policy.dart';

import 'tv_dpad_harness.dart';

void main() {
  group('QA-039 offline-first', () {
    test('hanging probe cannot block monitor start or stall past timeout',
        () async {
      final probe = _HangingProbe();
      final monitor = PollingConnectivityMonitor(
        probe: probe,
        interval: const Duration(hours: 1),
        probeTimeout: const Duration(milliseconds: 40),
        initial: ConnectivityStatus.online,
      );
      addTearDown(monitor.dispose);

      final offline = monitor.onStatusChanged.first;
      final started = Stopwatch()..start();
      await monitor.start();
      // start() must return immediately — first probe runs in the background.
      expect(started.elapsed, lessThan(const Duration(milliseconds: 100)));

      final status = await offline.timeout(const Duration(milliseconds: 500));
      expect(status, ConnectivityStatus.offline);
      expect(monitor.current, ConnectivityStatus.offline);
      expect(started.elapsed, lessThan(const Duration(seconds: 1)));
    });

    test('backend-down probe maps to offlineCached when cache exists', () async {
      final store = MemoryLocalMediaStore();
      await store.replaceChannels(const <ContentItem>[
        ContentItem(
          contentId: 'ch-1',
          type: ContentType.channel,
          title: 'Signal News',
        ),
      ]);

      expect(
        OfflineModePolicy.resolve(
          connectivity: ConnectivityStatus.offline,
          hasCachedContent: true,
        ),
        OfflinePresentation.offlineCached,
      );
      expect(
        OfflineModePolicy.resolve(
          connectivity: ConnectivityStatus.offline,
          hasCachedContent: false,
        ),
        OfflinePresentation.offlineEmpty,
      );

      final probe = _FakeProbe(false);
      final monitor = PollingConnectivityMonitor(
        probe: probe,
        interval: const Duration(hours: 1),
        probeTimeout: const Duration(milliseconds: 50),
        initial: ConnectivityStatus.online,
      );
      addTearDown(monitor.dispose);

      final offline = monitor.onStatusChanged.first;
      await monitor.start();
      expect(await offline, ConnectivityStatus.offline);
    });

    testWidgets('offlineCached Home stays interactive under OfflineBanner', (
      tester,
    ) async {
      final monitor = MemoryConnectivityMonitor(ConnectivityStatus.offline);
      await monitor.start();
      addTearDown(monitor.dispose);

      final store = MemoryLocalMediaStore();
      await store.replaceChannels(const <ContentItem>[
        ContentItem(
          contentId: 'ch-1',
          type: ContentType.channel,
          title: 'Signal News',
        ),
      ]);

      var retried = 0;
      await TvDpadHarness.pumpTv(
        tester,
        home: TvHomeConnectivityBinder(
          connectivity: monitor,
          localMediaStore: store,
          onStatusAction: () => retried++,
        ),
      );

      expect(find.byType(OfflineBanner), findsOneWidget);
      expect(find.textContaining('(cached)'), findsWidgets);
      expect(TvDpadHarness.focusedLabels(), contains('Evening news'));

      await TvDpadHarness.press(tester, LogicalKeyboardKey.arrowRight);
      expect(TvDpadHarness.focusedLabels(), isNot(contains('Evening news')));
      await TvDpadHarness.press(tester, LogicalKeyboardKey.arrowLeft);
      expect(TvDpadHarness.focusedLabels(), contains('Evening news'));

      await tester.tap(find.text('Try again'));
      await tester.pumpAndSettle();
      expect(retried, 1);
      expect(find.byType(TvHomePage), findsOneWidget);
    });

    test('playback network loss stops after capped retries (no infinite loop)',
        () async {
      final player = _FailingPlayer();
      final waits = <Duration>[];
      final coordinator = PlaybackRetryCoordinator(
        player: player,
        policy: const PlaybackRetryPolicy(
          maxAttempts: 2,
          initialDelay: Duration(milliseconds: 1),
          multiplier: 2,
          maxDelay: Duration(milliseconds: 10),
        ),
        wait: (delay) async {
          waits.add(delay);
        },
      );
      addTearDown(coordinator.dispose);

      final exhausted = <PlaybackError>[];
      final sub = coordinator.errors.listen(exhausted.add);
      addTearDown(sub.cancel);

      await coordinator.play(
        PlaybackRequest(streamUri: Uri.parse('https://cdn.example/live.m3u8')),
      );

      for (var i = 0; i < 5; i++) {
        player.emitNetworkError();
        await Future<void>.delayed(Duration.zero);
        await Future<void>.delayed(Duration.zero);
      }

      // Initial play + 2 automatic retries — never more.
      expect(player.playCount, 3);
      expect(waits.length, 2);
      expect(exhausted, isNotEmpty);
      expect(exhausted.last.kind, PlaybackErrorKind.network);
    });
  });
}

final class _HangingProbe implements ConnectivityProbe {
  @override
  Future<bool> isReachable() => Completer<bool>().future;
}

final class _FakeProbe implements ConnectivityProbe {
  _FakeProbe(this.reachable);
  final bool reachable;

  @override
  Future<bool> isReachable() async => reachable;
}

final class _FailingPlayer implements MediaPlayerController {
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

  void emitNetworkError() {
    _controller.add(
      const MediaPlayerStatus(
        phase: MediaPlayerPhase.error,
        message: 'ERROR_CODE_IO_NETWORK_CONNECTION_TIMEOUT',
      ),
    );
  }
}
