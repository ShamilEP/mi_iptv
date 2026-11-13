import '../../../sync/domain/entities/favorite_entry.dart';
import '../../domain/entities/companion_cached_browse.dart';
import '../../domain/entities/content_item.dart';
import 'companion_explore_item.dart';

/// Maps cached domain rows onto Companion Explore rails (CMP-006).
abstract final class CompanionExploreFromCache {
  static List<CompanionExploreItem> live(CompanionCachedBrowse browse) {
    return browse.channels
        .map(
          (item) => CompanionExploreItem(
            id: item.contentId,
            title: item.title,
            subtitle: 'Live',
            kind: CompanionExploreKind.live,
          ),
        )
        .toList(growable: false);
  }

  static List<CompanionExploreItem> movies(CompanionCachedBrowse browse) {
    return browse.vod
        .where((item) => item.type == ContentType.vodMovie)
        .map(
          (item) => CompanionExploreItem(
            id: item.contentId,
            title: item.title,
            subtitle: item.genres.isEmpty ? 'Movie' : item.genres.first,
            kind: CompanionExploreKind.movies,
          ),
        )
        .toList(growable: false);
  }

  static List<CompanionExploreItem> featured(CompanionCachedBrowse browse) {
    final fromVod = browse.vod
        .where((item) => item.type != ContentType.channel)
        .take(4)
        .map(
          (item) => CompanionExploreItem(
            id: item.contentId,
            title: item.title,
            subtitle: item.type == ContentType.vodSeries ? 'Series' : 'Featured',
            kind: CompanionExploreKind.featured,
          ),
        )
        .toList();
    if (fromVod.isNotEmpty) return List<CompanionExploreItem>.unmodifiable(fromVod);
    return browse.channels
        .take(2)
        .map(
          (item) => CompanionExploreItem(
            id: 'featured-${item.contentId}',
            title: item.title,
            subtitle: 'Featured',
            kind: CompanionExploreKind.featured,
          ),
        )
        .toList(growable: false);
  }

  static List<CompanionExploreItem> favorites(CompanionCachedBrowse browse) {
    return browse.favorites.map(_favorite).toList(growable: false);
  }

  static CompanionExploreItem _favorite(FavoriteEntry entry) {
    return CompanionExploreItem(
      id: entry.contentId,
      title: entry.title,
      subtitle: switch (entry.contentType) {
        ContentType.channel => 'Live',
        ContentType.vodMovie => 'Movie',
        ContentType.vodSeries => 'Series',
      },
      kind: CompanionExploreKind.favorites,
    );
  }
}
