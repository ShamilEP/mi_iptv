import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/features/catalog/domain/entities/content_item.dart';
import 'package:mi_iptv/features/favorites/presentation/tv/tv_favorites_from_domain.dart';
import 'package:mi_iptv/features/favorites/presentation/tv/tv_favorites_item.dart';
import 'package:mi_iptv/features/sync/domain/entities/favorite_entry.dart';
import 'package:mi_iptv/features/sync/domain/entities/sync_metadata.dart';

void main() {
  test('maps shared FavoriteEntry into TV favorites chrome', () {
    final entries = <FavoriteEntry>[
      FavoriteEntry(
        contentId: 'vod-ember',
        contentType: ContentType.vodMovie,
        title: 'Ember Night',
        order: 2,
        sync: SyncMetadata(
          syncVersion: 1,
          updatedAtServer: DateTime.utc(2026, 11, 12),
        ),
      ),
      FavoriteEntry(
        contentId: 'ch-12',
        contentType: ContentType.channel,
        title: '12 Signal News',
        order: 1,
        sync: SyncMetadata(
          syncVersion: 1,
          updatedAtServer: DateTime.utc(2026, 11, 12),
        ),
      ),
    ];

    final items = TvFavoritesFromDomain.items(entries);
    expect(items.map((e) => e.id), ['ch-12', 'vod-ember']);
    expect(items.first.kind, TvFavoritesKind.channel);
    expect(items.last.kind, TvFavoritesKind.vod);
    expect(items.last.subtitle, 'Movie');
  });
}
