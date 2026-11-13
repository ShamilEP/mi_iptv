import '../../../devices/domain/entities/linked_tv_snapshot.dart';
import '../../../sync/domain/entities/favorite_entry.dart';
import 'content_item.dart';

/// Companion offline browse payload from [LocalMediaStore] (CMP-006 / NFR-011).
final class CompanionCachedBrowse {
  const CompanionCachedBrowse({
    this.channels = const <ContentItem>[],
    this.vod = const <ContentItem>[],
    this.favorites = const <FavoriteEntry>[],
    this.linkedTv,
  });

  final List<ContentItem> channels;
  final List<ContentItem> vod;
  final List<FavoriteEntry> favorites;
  final LinkedTvSnapshot? linkedTv;

  bool get hasCatalog => channels.isNotEmpty || vod.isNotEmpty;

  bool get hasFavorites => favorites.isNotEmpty;

  bool get isEmpty =>
      !hasCatalog && !hasFavorites && linkedTv == null;
}
