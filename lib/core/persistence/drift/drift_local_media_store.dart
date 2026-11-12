import 'package:drift/drift.dart';

import '../../../features/catalog/domain/entities/content_item.dart';
import '../../../features/settings/domain/entities/cached_setting.dart';
import '../../../features/sources/domain/entities/cached_source.dart';
import '../../../features/sync/domain/entities/favorite_entry.dart';
import '../../../features/sync/domain/entities/playback_progress.dart';
import '../../../features/sync/domain/entities/sync_metadata.dart';
import '../../../features/sync/domain/entities/sync_outbox_entry.dart';
import '../local_media_store.dart';
import 'app_database.dart';
import 'content_item_codec.dart';

/// SQLite-backed [LocalMediaStore] via Drift (TV-007).
final class DriftLocalMediaStore implements LocalMediaStore {
  DriftLocalMediaStore(this._db, {ContentItemCodec? codec})
      : _codec = codec ?? const ContentItemCodec();

  final AppDatabase _db;
  final ContentItemCodec _codec;

  @override
  Future<void> replaceChannels(List<ContentItem> channels) async {
    final rows = channels
        .where((c) => c.type == ContentType.channel)
        .map(_channelCompanion)
        .toList(growable: false);
    await _db.transaction(() async {
      await _db.delete(_db.cachedChannels).go();
      await _db.batch((batch) {
        batch.insertAll(_db.cachedChannels, rows);
      });
    });
  }

  @override
  Future<List<ContentItem>> loadChannels() async {
    final rows = await _db.select(_db.cachedChannels).get();
    return rows.map(_decodeChannel).toList(growable: false);
  }

  @override
  Future<void> replaceVodMetadata(List<ContentItem> vodItems) async {
    final rows = vodItems
        .where(
          (c) =>
              c.type == ContentType.vodMovie || c.type == ContentType.vodSeries,
        )
        .map(_vodCompanion)
        .toList(growable: false);
    await _db.transaction(() async {
      await _db.delete(_db.cachedVodItems).go();
      await _db.batch((batch) {
        batch.insertAll(_db.cachedVodItems, rows);
      });
    });
  }

  @override
  Future<List<ContentItem>> loadVodMetadata() async {
    final rows = await _db.select(_db.cachedVodItems).get();
    return rows.map(_decodeVod).toList(growable: false);
  }

  @override
  Future<void> upsertPlaybackProgress(PlaybackProgress progress) async {
    await _db
        .into(_db.playbackProgressRows)
        .insertOnConflictUpdate(
          PlaybackProgressRowsCompanion.insert(
            contentId: progress.contentId,
            positionMs: progress.position.inMilliseconds,
            durationMs: Value(progress.duration?.inMilliseconds),
            syncVersion: progress.sync.syncVersion,
            updatedAtServer: progress.sync.updatedAtServer,
            forceReset: Value(progress.forceReset),
          ),
        );
  }

  @override
  Future<PlaybackProgress?> loadPlaybackProgress(String contentId) async {
    final row = await (_db.select(_db.playbackProgressRows)
          ..where((t) => t.contentId.equals(contentId)))
        .getSingleOrNull();
    return row == null ? null : _decodePlayback(row);
  }

  @override
  Future<List<PlaybackProgress>> loadAllPlaybackProgress() async {
    final rows = await _db.select(_db.playbackProgressRows).get();
    return rows.map(_decodePlayback).toList(growable: false);
  }

  @override
  Future<void> replaceFavorites(List<FavoriteEntry> favorites) async {
    final rows = favorites
        .map(
          (f) => FavoriteRowsCompanion.insert(
            contentId: f.contentId,
            contentType: f.contentType.name,
            title: f.title,
            sortOrder: f.order,
            syncVersion: f.sync.syncVersion,
            updatedAtServer: f.sync.updatedAtServer,
          ),
        )
        .toList(growable: false);
    await _db.transaction(() async {
      await _db.delete(_db.favoriteRows).go();
      await _db.batch((batch) {
        batch.insertAll(_db.favoriteRows, rows);
      });
    });
  }

  @override
  Future<List<FavoriteEntry>> loadFavorites() async {
    final rows = await (_db.select(_db.favoriteRows)
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();
    return rows
        .map(
          (r) => FavoriteEntry(
            contentId: r.contentId,
            contentType: ContentType.values.byName(r.contentType),
            title: r.title,
            order: r.sortOrder,
            sync: SyncMetadata(
              syncVersion: r.syncVersion,
              updatedAtServer: r.updatedAtServer,
            ),
          ),
        )
        .toList(growable: false);
  }

  @override
  Future<void> replaceSources(List<CachedSource> sources) async {
    final rows = sources
        .map(
          (s) => SourceRowsCompanion.insert(
            sourceId: s.sourceId,
            kind: s.kind,
            displayName: s.displayName,
            baseUrl: Value(_sanitizeBaseUrl(s.baseUrl)),
          ),
        )
        .toList(growable: false);
    await _db.transaction(() async {
      await _db.delete(_db.sourceRows).go();
      await _db.batch((batch) {
        batch.insertAll(_db.sourceRows, rows);
      });
    });
  }

  @override
  Future<List<CachedSource>> loadSources() async {
    final rows = await _db.select(_db.sourceRows).get();
    return rows
        .map(
          (r) => CachedSource(
            sourceId: r.sourceId,
            kind: r.kind,
            displayName: r.displayName,
            baseUrl: r.baseUrl == null || r.baseUrl!.isEmpty
                ? null
                : Uri.parse(r.baseUrl!),
          ),
        )
        .toList(growable: false);
  }

  @override
  Future<void> upsertSetting(CachedSetting setting) async {
    await _db.into(_db.settingRows).insertOnConflictUpdate(
          SettingRowsCompanion.insert(
            key: setting.key,
            value: setting.value,
          ),
        );
  }

  @override
  Future<CachedSetting?> loadSetting(String key) async {
    final row = await (_db.select(_db.settingRows)
          ..where((t) => t.key.equals(key)))
        .getSingleOrNull();
    if (row == null) return null;
    return CachedSetting(key: row.key, value: row.value);
  }

  @override
  Future<List<CachedSetting>> loadSettings() async {
    final rows = await _db.select(_db.settingRows).get();
    return rows
        .map((r) => CachedSetting(key: r.key, value: r.value))
        .toList(growable: false);
  }

  @override
  Future<void> enqueueOutbox(SyncOutboxEntry entry) async {
    await _db.into(_db.outboxRows).insertOnConflictUpdate(
          OutboxRowsCompanion.insert(
            id: entry.id,
            entityKind: entry.entityKind.name,
            operation: entry.operation.name,
            entityId: entry.entityId,
            payloadJson: entry.payloadJson,
            enqueuedAt: entry.enqueuedAt,
            attempts: Value(entry.attempts),
          ),
        );
  }

  @override
  Future<List<SyncOutboxEntry>> loadOutbox() async {
    final rows = await (_db.select(_db.outboxRows)
          ..orderBy([(t) => OrderingTerm.asc(t.enqueuedAt)]))
        .get();
    return rows
        .map(
          (r) => SyncOutboxEntry(
            id: r.id,
            entityKind: SyncOutboxEntityKind.values.byName(r.entityKind),
            operation: SyncOutboxOperation.values.byName(r.operation),
            entityId: r.entityId,
            payloadJson: r.payloadJson,
            enqueuedAt: r.enqueuedAt,
            attempts: r.attempts,
          ),
        )
        .toList(growable: false);
  }

  @override
  Future<void> removeOutbox(String id) async {
    await (_db.delete(_db.outboxRows)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<void> clearOutbox() async {
    await _db.delete(_db.outboxRows).go();
  }

  CachedChannelsCompanion _channelCompanion(ContentItem item) {
    final encoded = _codec.encodeRow(item);
    return CachedChannelsCompanion.insert(
      contentId: encoded['contentId']! as String,
      title: encoded['title']! as String,
      type: encoded['type']! as String,
      posterUrl: Value(encoded['posterUrl'] as String?),
      bannerUrl: Value(encoded['bannerUrl'] as String?),
      genresJson: Value(encoded['genresJson']! as String),
      sourcesJson: Value(encoded['sourcesJson']! as String),
    );
  }

  CachedVodItemsCompanion _vodCompanion(ContentItem item) {
    final encoded = _codec.encodeRow(item);
    return CachedVodItemsCompanion.insert(
      contentId: encoded['contentId']! as String,
      title: encoded['title']! as String,
      type: encoded['type']! as String,
      posterUrl: Value(encoded['posterUrl'] as String?),
      bannerUrl: Value(encoded['bannerUrl'] as String?),
      genresJson: Value(encoded['genresJson']! as String),
      sourcesJson: Value(encoded['sourcesJson']! as String),
    );
  }

  ContentItem _decodeChannel(CachedChannel row) {
    return _codec.decodeRow(
      contentId: row.contentId,
      type: row.type,
      title: row.title,
      posterUrl: row.posterUrl,
      bannerUrl: row.bannerUrl,
      genresJson: row.genresJson,
      sourcesJson: row.sourcesJson,
    );
  }

  ContentItem _decodeVod(CachedVodItem row) {
    return _codec.decodeRow(
      contentId: row.contentId,
      type: row.type,
      title: row.title,
      posterUrl: row.posterUrl,
      bannerUrl: row.bannerUrl,
      genresJson: row.genresJson,
      sourcesJson: row.sourcesJson,
    );
  }

  PlaybackProgress _decodePlayback(PlaybackProgressRow row) {
    return PlaybackProgress(
      contentId: row.contentId,
      position: Duration(milliseconds: row.positionMs),
      duration: row.durationMs == null
          ? null
          : Duration(milliseconds: row.durationMs!),
      sync: SyncMetadata(
        syncVersion: row.syncVersion,
        updatedAtServer: row.updatedAtServer,
      ),
      forceReset: row.forceReset,
    );
  }

  String? _sanitizeBaseUrl(Uri? uri) {
    if (uri == null) return null;
    if (uri.userInfo.isEmpty) return uri.toString();
    return uri.replace(userInfo: '').toString();
  }
}
