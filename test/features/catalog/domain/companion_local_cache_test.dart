import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/persistence/memory_local_media_store.dart';
import 'package:mi_iptv/features/catalog/domain/entities/content_item.dart';
import 'package:mi_iptv/features/catalog/domain/services/companion_local_cache.dart';
import 'package:mi_iptv/features/devices/data/repositories/local_linked_tv_status_store.dart';
import 'package:mi_iptv/features/devices/domain/entities/linked_tv_snapshot.dart';
import 'package:mi_iptv/features/sync/domain/entities/favorite_entry.dart';
import 'package:mi_iptv/features/sync/domain/entities/sync_metadata.dart';

void main() {
  test('CMP-006 CompanionLocalCache round-trips catalog, favorites, TV status',
      () async {
    final media = MemoryLocalMediaStore();
    final cache = CompanionLocalCache(
      mediaStore: media,
      linkedTvStatusStore: LocalLinkedTvStatusStore(media),
    );

    await cache.saveCatalog(
      channels: const <ContentItem>[
        ContentItem(
          contentId: 'ch-1',
          type: ContentType.channel,
          title: 'Signal News',
        ),
      ],
      vod: const <ContentItem>[
        ContentItem(
          contentId: 'vod-1',
          type: ContentType.vodMovie,
          title: 'Harbor Lights',
          genres: <String>['Drama'],
        ),
      ],
    );
    await cache.saveFavorites(<FavoriteEntry>[
      FavoriteEntry(
        contentId: 'vod-1',
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
        displayName: 'Living room',
        lastKnownOnline: false,
        updatedAt: DateTime.utc(2026, 11, 13),
      ),
    );

    final browse = await cache.loadBrowse();
    expect(browse.hasCatalog, isTrue);
    expect(browse.hasFavorites, isTrue);
    expect(browse.channels.single.title, 'Signal News');
    expect(browse.vod.single.title, 'Harbor Lights');
    expect(browse.favorites.single.title, 'Harbor Lights');
    expect(browse.linkedTv!.displayName, 'Living room');
    expect(browse.linkedTv!.lastKnownOnline, isFalse);
  });
}
