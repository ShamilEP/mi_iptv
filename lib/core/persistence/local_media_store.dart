import '../../features/catalog/domain/entities/content_item.dart';
import '../../features/settings/domain/entities/cached_setting.dart';
import '../../features/sources/domain/entities/cached_source.dart';
import '../../features/sync/domain/entities/favorite_entry.dart';
import '../../features/sync/domain/entities/playback_progress.dart';
import '../../features/sync/domain/entities/sync_outbox_entry.dart';

/// Durable local cache / outbox port (TV-007 — Room/SQLite on device).
///
/// Caches channels, VOD metadata, playback state, favorites, sources
/// (**no secrets**), settings, and the sync outbox.
abstract interface class LocalMediaStore {
  Future<void> replaceChannels(List<ContentItem> channels);
  Future<List<ContentItem>> loadChannels();

  Future<void> replaceVodMetadata(List<ContentItem> vodItems);
  Future<List<ContentItem>> loadVodMetadata();

  Future<void> upsertPlaybackProgress(PlaybackProgress progress);
  Future<PlaybackProgress?> loadPlaybackProgress(String contentId);
  Future<List<PlaybackProgress>> loadAllPlaybackProgress();

  Future<void> replaceFavorites(List<FavoriteEntry> favorites);
  Future<List<FavoriteEntry>> loadFavorites();

  Future<void> replaceSources(List<CachedSource> sources);
  Future<List<CachedSource>> loadSources();

  Future<void> upsertSetting(CachedSetting setting);
  Future<CachedSetting?> loadSetting(String key);
  Future<List<CachedSetting>> loadSettings();

  Future<void> enqueueOutbox(SyncOutboxEntry entry);
  Future<List<SyncOutboxEntry>> loadOutbox();
  Future<void> removeOutbox(String id);
  Future<void> clearOutbox();
}
