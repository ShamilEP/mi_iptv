import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/persistence/drift/app_database.dart';
import 'package:mi_iptv/core/persistence/drift/drift_local_media_store.dart';
import 'package:mi_iptv/features/catalog/domain/entities/content_item.dart';
import 'package:mi_iptv/features/settings/domain/entities/cached_setting.dart';
import 'package:mi_iptv/features/sources/domain/entities/cached_source.dart';
import 'package:mi_iptv/features/sync/domain/entities/favorite_entry.dart';
import 'package:mi_iptv/features/sync/domain/entities/playback_progress.dart';
import 'package:mi_iptv/features/sync/domain/entities/sync_metadata.dart';
import 'package:mi_iptv/features/sync/domain/entities/sync_outbox_entry.dart';

void main() {
  late AppDatabase db;
  late DriftLocalMediaStore store;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    store = DriftLocalMediaStore(db);
  });

  tearDown(() async {
    await db.close();
  });

  final sync = SyncMetadata(
    syncVersion: 2,
    updatedAtServer: DateTime.utc(2026, 11, 12, 4),
  );

  test('persists all LocalMediaStore buckets durably in SQLite', () async {
    await store.replaceChannels(const [
      ContentItem(
        contentId: 'ch-1',
        type: ContentType.channel,
        title: 'News',
      ),
    ]);
    await store.replaceVodMetadata(const [
      ContentItem(
        contentId: 'vod-1',
        type: ContentType.vodMovie,
        title: 'Film',
      ),
    ]);
    await store.upsertPlaybackProgress(
      PlaybackProgress(
        contentId: 'vod-1',
        position: const Duration(minutes: 12),
        sync: sync,
      ),
    );
    await store.replaceFavorites([
      FavoriteEntry(
        contentId: 'ch-1',
        contentType: ContentType.channel,
        title: 'News',
        order: 0,
        sync: sync,
      ),
    ]);
    await store.replaceSources([
      CachedSource(
        sourceId: 'src-1',
        kind: 'xtream',
        displayName: 'Provider',
        baseUrl: Uri.parse('https://user:tok@host.example'),
      ),
    ]);
    await store.upsertSetting(
      const CachedSetting(key: 'subs.lang', value: 'en'),
    );
    await store.enqueueOutbox(
      SyncOutboxEntry(
        id: 'ob-1',
        entityKind: SyncOutboxEntityKind.playbackProgress,
        operation: SyncOutboxOperation.upsert,
        entityId: 'vod-1',
        payloadJson: '{"contentId":"vod-1"}',
        enqueuedAt: DateTime.utc(2026, 11, 12, 5),
      ),
    );

    expect((await store.loadChannels()).single.title, 'News');
    expect((await store.loadVodMetadata()).single.contentId, 'vod-1');
    expect(
      (await store.loadPlaybackProgress('vod-1'))?.position.inMinutes,
      12,
    );
    expect((await store.loadFavorites()).single.order, 0);
    final source = (await store.loadSources()).single;
    expect(source.baseUrl?.userInfo, isEmpty);
    expect(source.baseUrl.toString(), 'https://host.example');
    expect((await store.loadSetting('subs.lang'))?.value, 'en');
    expect((await store.loadOutbox()).single.id, 'ob-1');

    await store.removeOutbox('ob-1');
    expect(await store.loadOutbox(), isEmpty);
  });
}
