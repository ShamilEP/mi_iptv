import '../../../catalog/domain/entities/content_item.dart';
import '../../../sync/domain/entities/favorite_entry.dart';
import 'tv_favorites_item.dart';

/// Maps shared domain favorites into the TV Favorites shell (TV-005).
abstract final class TvFavoritesFromDomain {
  static TvFavoritesItem item(FavoriteEntry entry) {
    return TvFavoritesItem(
      id: entry.contentId,
      title: entry.title,
      subtitle: _subtitle(entry.contentType),
      kind: _kind(entry.contentType),
      order: entry.order,
    );
  }

  static List<TvFavoritesItem> items(Iterable<FavoriteEntry> entries) {
    final mapped = entries.map(item).toList(growable: false);
    return List<TvFavoritesItem>.unmodifiable(
      [...mapped]..sort((a, b) => a.order.compareTo(b.order)),
    );
  }

  static TvFavoritesKind _kind(ContentType type) {
    return switch (type) {
      ContentType.channel => TvFavoritesKind.channel,
      ContentType.vodMovie || ContentType.vodSeries => TvFavoritesKind.vod,
    };
  }

  static String _subtitle(ContentType type) {
    return switch (type) {
      ContentType.channel => 'Live',
      ContentType.vodMovie => 'Movie',
      ContentType.vodSeries => 'Series',
    };
  }
}
