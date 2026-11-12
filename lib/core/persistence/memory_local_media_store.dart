import '../../features/catalog/domain/entities/content_item.dart';
import '../../features/settings/domain/entities/cached_setting.dart';
import '../../features/sources/domain/entities/cached_source.dart';
import '../../features/sync/domain/entities/favorite_entry.dart';
import '../../features/sync/domain/entities/playback_progress.dart';
import '../../features/sync/domain/entities/sync_outbox_entry.dart';
import 'local_media_store.dart';

/// Process-local [LocalMediaStore] for unit tests (TV-007).
///
/// Not durable — SQLite/Drift adapter replaces this after package approval.
final class MemoryLocalMediaStore implements LocalMediaStore {
  final Map<String, ContentItem> _channels = <String, ContentItem>{};
  final Map<String, ContentItem> _vod = <String, ContentItem>{};
  final Map<String, PlaybackProgress> _playback = <String, PlaybackProgress>{};
  final Map<String, FavoriteEntry> _favorites = <String, FavoriteEntry>{};
  final Map<String, CachedSource> _sources = <String, CachedSource>{};
  final Map<String, CachedSetting> _settings = <String, CachedSetting>{};
  final Map<String, SyncOutboxEntry> _outbox = <String, SyncOutboxEntry>{};

  @override
  Future<void> replaceChannels(List<ContentItem> channels) async {
    _channels
      ..clear()
      ..addEntries(
        channels
            .where((c) => c.type == ContentType.channel)
            .map((c) => MapEntry(c.contentId, c)),
      );
  }

  @override
  Future<List<ContentItem>> loadChannels() async =>
      List<ContentItem>.unmodifiable(_channels.values.toList(growable: false));

  @override
  Future<void> replaceVodMetadata(List<ContentItem> vodItems) async {
    _vod
      ..clear()
      ..addEntries(
        vodItems
            .where(
              (c) =>
                  c.type == ContentType.vodMovie ||
                  c.type == ContentType.vodSeries,
            )
            .map((c) => MapEntry(c.contentId, c)),
      );
  }

  @override
  Future<List<ContentItem>> loadVodMetadata() async =>
      List<ContentItem>.unmodifiable(_vod.values.toList(growable: false));

  @override
  Future<void> upsertPlaybackProgress(PlaybackProgress progress) async {
    _playback[progress.contentId] = progress;
  }

  @override
  Future<PlaybackProgress?> loadPlaybackProgress(String contentId) async =>
      _playback[contentId];

  @override
  Future<List<PlaybackProgress>> loadAllPlaybackProgress() async =>
      List<PlaybackProgress>.unmodifiable(
        _playback.values.toList(growable: false),
      );

  @override
  Future<void> replaceFavorites(List<FavoriteEntry> favorites) async {
    _favorites
      ..clear()
      ..addEntries(favorites.map((f) => MapEntry(f.contentId, f)));
  }

  @override
  Future<List<FavoriteEntry>> loadFavorites() async {
    final values = _favorites.values.toList(growable: false)
      ..sort((a, b) => a.order.compareTo(b.order));
    return List<FavoriteEntry>.unmodifiable(values);
  }

  @override
  Future<void> replaceSources(List<CachedSource> sources) async {
    _sources
      ..clear()
      ..addEntries(sources.map((s) => MapEntry(s.sourceId, s)));
  }

  @override
  Future<List<CachedSource>> loadSources() async =>
      List<CachedSource>.unmodifiable(_sources.values.toList(growable: false));

  @override
  Future<void> upsertSetting(CachedSetting setting) async {
    _settings[setting.key] = setting;
  }

  @override
  Future<CachedSetting?> loadSetting(String key) async => _settings[key];

  @override
  Future<List<CachedSetting>> loadSettings() async =>
      List<CachedSetting>.unmodifiable(
        _settings.values.toList(growable: false),
      );

  @override
  Future<void> enqueueOutbox(SyncOutboxEntry entry) async {
    _outbox[entry.id] = entry;
  }

  @override
  Future<List<SyncOutboxEntry>> loadOutbox() async {
    final values = _outbox.values.toList(growable: false)
      ..sort((a, b) => a.enqueuedAt.compareTo(b.enqueuedAt));
    return List<SyncOutboxEntry>.unmodifiable(values);
  }

  @override
  Future<void> removeOutbox(String id) async {
    _outbox.remove(id);
  }

  @override
  Future<void> clearOutbox() async {
    _outbox.clear();
  }
}
