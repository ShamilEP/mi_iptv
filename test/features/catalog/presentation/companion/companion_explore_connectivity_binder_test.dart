import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/network/connectivity_status.dart';
import 'package:mi_iptv/core/network/memory_connectivity_monitor.dart';
import 'package:mi_iptv/core/persistence/memory_local_media_store.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/core/widgets/offline_banner.dart';
import 'package:mi_iptv/core/widgets/status_pattern.dart';
import 'package:mi_iptv/features/catalog/domain/entities/content_item.dart';
import 'package:mi_iptv/features/catalog/domain/services/companion_local_cache.dart';
import 'package:mi_iptv/features/catalog/presentation/companion/companion_explore_connectivity_binder.dart';
import 'package:mi_iptv/features/catalog/presentation/companion/companion_explore_copy.dart';
import 'package:mi_iptv/features/devices/data/repositories/local_linked_tv_status_store.dart';
import 'package:mi_iptv/features/devices/domain/entities/linked_tv_snapshot.dart';
import 'package:mi_iptv/features/sync/domain/entities/favorite_entry.dart';
import 'package:mi_iptv/features/sync/domain/entities/sync_metadata.dart';

void main() {
  Future<CompanionLocalCache> seededCache() async {
    final media = MemoryLocalMediaStore();
    final cache = CompanionLocalCache(
      mediaStore: media,
      linkedTvStatusStore: LocalLinkedTvStatusStore(media),
    );
    await cache.saveCatalog(
      channels: const <ContentItem>[
        ContentItem(
          contentId: 'ch-12',
          type: ContentType.channel,
          title: '12 Signal News',
        ),
      ],
      vod: const <ContentItem>[
        ContentItem(
          contentId: 'movie-1',
          type: ContentType.vodMovie,
          title: 'Harbor Lights',
        ),
      ],
    );
    await cache.saveFavorites(<FavoriteEntry>[
      FavoriteEntry(
        contentId: 'movie-1',
        contentType: ContentType.vodMovie,
        title: 'Harbor Lights',
        order: 0,
        sync: SyncMetadata(
          syncVersion: 1,
          updatedAtServer: DateTime.utc(2026, 11, 1),
        ),
      ),
    ]);
    await cache.saveLinkedTv(
      LinkedTvSnapshot(
        deviceId: 'tv-1',
        displayName: 'Den TV',
        lastKnownOnline: true,
        updatedAt: DateTime.utc(2026, 11, 13),
      ),
    );
    return cache;
  }

  testWidgets('CMP-006 offlineCached shows banner, cached rails, favorites', (
    tester,
  ) async {
    final monitor = MemoryConnectivityMonitor(ConnectivityStatus.offline);
    await monitor.start();
    final cache = await seededCache();

    await tester.binding.setSurfaceSize(const Size(390, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.companionLight(),
        home: CompanionExploreConnectivityBinder(
          connectivity: monitor,
          localCache: cache,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(OfflineBanner), findsOneWidget);
    expect(find.textContaining('(cached)'), findsWidgets);
    expect(find.text('12 Signal News'), findsOneWidget);
    expect(find.textContaining(CompanionExploreCopy.favoritesTitle), findsOneWidget);
    expect(find.byType(OfflinePattern), findsNothing);

    await monitor.dispose();
  });

  testWidgets('CMP-006 offline empty shows OfflinePattern', (tester) async {
    final monitor = MemoryConnectivityMonitor(ConnectivityStatus.offline);
    await monitor.start();
    final media = MemoryLocalMediaStore();
    final cache = CompanionLocalCache(
      mediaStore: media,
      linkedTvStatusStore: LocalLinkedTvStatusStore(media),
    );

    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.companionLight(),
        home: CompanionExploreConnectivityBinder(
          connectivity: monitor,
          localCache: cache,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(OfflinePattern), findsOneWidget);
    expect(find.byType(OfflineBanner), findsNothing);

    await monitor.dispose();
  });

  testWidgets('CMP-006 retry / online clears offline state', (tester) async {
    final monitor = MemoryConnectivityMonitor(ConnectivityStatus.offline);
    await monitor.start();
    final cache = await seededCache();

    await tester.binding.setSurfaceSize(const Size(390, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.companionLight(),
        home: CompanionExploreConnectivityBinder(
          connectivity: monitor,
          localCache: cache,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(OfflineBanner), findsOneWidget);

    monitor.emit(ConnectivityStatus.online);
    await tester.pumpAndSettle();
    expect(find.byType(OfflineBanner), findsNothing);
    expect(find.byType(OfflinePattern), findsNothing);
    expect(find.textContaining('(cached)'), findsNothing);

    await monitor.dispose();
  });
}
