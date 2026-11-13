import '../persistence/local_media_store.dart';

/// Whether the local media cache can back offline browse (TV-010 / CMP-006).
abstract final class OfflineCacheAvailability {
  static Future<bool> hasBrowseableCache(LocalMediaStore store) async {
    final channels = await store.loadChannels();
    if (channels.isNotEmpty) return true;
    final vod = await store.loadVodMetadata();
    if (vod.isNotEmpty) return true;
    final progress = await store.loadAllPlaybackProgress();
    if (progress.isNotEmpty) return true;
    // Companion offline browse also treats favorites as usable cache (CMP-006).
    final favorites = await store.loadFavorites();
    return favorites.isNotEmpty;
  }
}
