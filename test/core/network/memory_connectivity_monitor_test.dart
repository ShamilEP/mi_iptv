import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/network/connectivity_probe.dart';
import 'package:mi_iptv/core/network/connectivity_status.dart';
import 'package:mi_iptv/core/network/memory_connectivity_monitor.dart';
import 'package:mi_iptv/core/network/offline_cache_availability.dart';
import 'package:mi_iptv/core/network/offline_mode_policy.dart';
import 'package:mi_iptv/core/network/offline_mode_resolver.dart';
import 'package:mi_iptv/core/network/polling_connectivity_monitor.dart';
import 'package:mi_iptv/core/persistence/memory_local_media_store.dart';
import 'package:mi_iptv/features/catalog/domain/entities/content_item.dart';
import 'package:mi_iptv/features/sync/domain/entities/favorite_entry.dart';
import 'package:mi_iptv/features/sync/domain/entities/sync_metadata.dart';

void main() {
  test('MemoryConnectivityMonitor emits status changes', () async {
    final monitor = MemoryConnectivityMonitor();
    await monitor.start();
    expect(monitor.current, ConnectivityStatus.online);

    final future = monitor.onStatusChanged.first;
    monitor.emit(ConnectivityStatus.offline);
    expect(await future, ConnectivityStatus.offline);
    expect(monitor.current, ConnectivityStatus.offline);
    await monitor.dispose();
  });

  test('PollingConnectivityMonitor respects probe results', () async {
    final probe = _FakeProbe(false);
    final monitor = PollingConnectivityMonitor(
      probe: probe,
      interval: const Duration(hours: 1),
      initial: ConnectivityStatus.online,
    );
    final future = monitor.onStatusChanged.first;
    await monitor.start();
    expect(await future, ConnectivityStatus.offline);
    await monitor.dispose();
  });

  test('PollingConnectivityMonitor times out hanging probes as offline',
      () async {
    final monitor = PollingConnectivityMonitor(
      probe: _HangingProbe(),
      interval: const Duration(hours: 1),
      probeTimeout: const Duration(milliseconds: 40),
      initial: ConnectivityStatus.online,
    );
    final future = monitor.onStatusChanged.first;
    await monitor.start();
    expect(await future.timeout(const Duration(milliseconds: 500)),
        ConnectivityStatus.offline);
    await monitor.dispose();
  });

  test('OfflineModeResolver uses LocalMediaStore cache', () async {
    final store = MemoryLocalMediaStore();
    final monitor = MemoryConnectivityMonitor(ConnectivityStatus.offline);
    final resolver = OfflineModeResolver(
      connectivity: monitor,
      localMediaStore: store,
    );

    expect(await resolver.resolve(), OfflinePresentation.offlineEmpty);

    await store.replaceChannels(const <ContentItem>[
      ContentItem(
        contentId: 'ch-1',
        type: ContentType.channel,
        title: 'Signal News',
      ),
    ]);
    expect(await OfflineCacheAvailability.hasBrowseableCache(store), isTrue);
    expect(await resolver.resolve(), OfflinePresentation.offlineCached);
  });

  test('OfflineCacheAvailability treats favorites as browseable (CMP-006)', () async {
    final store = MemoryLocalMediaStore();
    expect(await OfflineCacheAvailability.hasBrowseableCache(store), isFalse);

    await store.replaceFavorites(<FavoriteEntry>[
      FavoriteEntry(
        contentId: 'fav-1',
        contentType: ContentType.vodMovie,
        title: 'Harbor Lights',
        order: 0,
        sync: SyncMetadata(
          syncVersion: 1,
          updatedAtServer: DateTime.utc(2026, 11, 1),
        ),
      ),
    ]);
    expect(await OfflineCacheAvailability.hasBrowseableCache(store), isTrue);
  });
}

final class _FakeProbe implements ConnectivityProbe {
  _FakeProbe(this.reachable);
  final bool reachable;

  @override
  Future<bool> isReachable() async => reachable;
}

final class _HangingProbe implements ConnectivityProbe {
  @override
  Future<bool> isReachable() => Completer<bool>().future;
}
