import '../../../../core/persistence/local_media_store.dart';
import '../../../devices/domain/entities/linked_tv_snapshot.dart';
import '../../../devices/domain/repositories/linked_tv_status_store.dart';
import '../../../sync/domain/entities/favorite_entry.dart';
import '../entities/companion_cached_browse.dart';
import '../entities/content_item.dart';

/// Reads / writes Companion catalog, favorites, and TV status cache (CMP-006).
final class CompanionLocalCache {
  const CompanionLocalCache({
    required LocalMediaStore mediaStore,
    required LinkedTvStatusStore linkedTvStatusStore,
  })  : _media = mediaStore,
        _linkedTv = linkedTvStatusStore;

  final LocalMediaStore _media;
  final LinkedTvStatusStore _linkedTv;

  Future<CompanionCachedBrowse> loadBrowse() async {
    final channels = await _media.loadChannels();
    final vod = await _media.loadVodMetadata();
    final favorites = await _media.loadFavorites();
    final linkedTv = await _linkedTv.load();
    return CompanionCachedBrowse(
      channels: channels,
      vod: vod,
      favorites: favorites,
      linkedTv: linkedTv,
    );
  }

  Future<void> saveCatalog({
    List<ContentItem> channels = const <ContentItem>[],
    List<ContentItem> vod = const <ContentItem>[],
  }) async {
    await _media.replaceChannels(channels);
    await _media.replaceVodMetadata(vod);
  }

  Future<void> saveFavorites(List<FavoriteEntry> favorites) {
    return _media.replaceFavorites(favorites);
  }

  Future<void> saveLinkedTv(LinkedTvSnapshot snapshot) {
    return _linkedTv.save(snapshot);
  }
}
