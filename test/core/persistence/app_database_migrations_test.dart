import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/persistence/drift/app_database.dart';
import 'package:mi_iptv/core/persistence/drift/app_database_migrations.dart';
import 'package:mi_iptv/core/persistence/drift/drift_local_media_store.dart';
import 'package:mi_iptv/core/persistence/local_media_schema_exception.dart';
import 'package:mi_iptv/features/catalog/domain/entities/content_item.dart';
import 'package:mi_iptv/features/settings/domain/entities/cached_setting.dart';
import 'package:mi_iptv/features/sources/domain/entities/cached_source.dart';
import 'package:mi_iptv/features/sync/domain/entities/favorite_entry.dart';
import 'package:mi_iptv/features/sync/domain/entities/playback_progress.dart';
import 'package:mi_iptv/features/sync/domain/entities/sync_metadata.dart';
import 'package:mi_iptv/features/sync/domain/entities/sync_outbox_entry.dart';

void main() {
  final sync = SyncMetadata(
    syncVersion: 3,
    updatedAtServer: DateTime.utc(2026, 11, 16, 4),
  );

  test('TV-015 current schema version is 2', () {
    expect(AppDatabaseMigrations.currentSchemaVersion, 2);
  });

  test('TV-015 fresh DB writes schema watermark', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    // Touch the DB so migrations run.
    final store = DriftLocalMediaStore(db);
    await store.loadSettings();

    expect(await AppDatabaseMigrations.readSchemaWatermark(db), '2');
  });

  test(
    'TV-015 v1→v2 upgrade preserves favorites, progress, sources, outbox',
    () async {
      final dir = await Directory.systemTemp.createTemp('tv015_mig_');
      addTearDown(() => dir.delete(recursive: true));
      final file = File('${dir.path}/mi_iptv_local_media.sqlite');

      final v1 = AppDatabase.legacyV1(NativeDatabase(file));
      final storeV1 = DriftLocalMediaStore(v1);

      await storeV1.replaceChannels(const [
        ContentItem(
          contentId: 'ch-1',
          type: ContentType.channel,
          title: 'News',
        ),
      ]);
      await storeV1.replaceVodMetadata(const [
        ContentItem(
          contentId: 'vod-1',
          type: ContentType.vodMovie,
          title: 'Film',
        ),
      ]);
      await storeV1.upsertPlaybackProgress(
        PlaybackProgress(
          contentId: 'vod-1',
          position: const Duration(minutes: 42),
          sync: sync,
        ),
      );
      await storeV1.replaceFavorites([
        FavoriteEntry(
          contentId: 'ch-1',
          contentType: ContentType.channel,
          title: 'News',
          order: 0,
          sync: sync,
        ),
      ]);
      await storeV1.replaceSources([
        CachedSource(
          sourceId: 'src-1',
          kind: 'm3u',
          displayName: 'Playlist',
          baseUrl: Uri.parse('https://cdn.example/list.m3u'),
        ),
      ]);
      await storeV1.upsertSetting(
        const CachedSetting(key: 'ui.theme', value: 'tv-dark'),
      );
      await storeV1.enqueueOutbox(
        SyncOutboxEntry(
          id: 'ob-1',
          entityKind: SyncOutboxEntityKind.favorite,
          operation: SyncOutboxOperation.upsert,
          entityId: 'ch-1',
          payloadJson: '{"contentId":"ch-1"}',
          enqueuedAt: DateTime.utc(2026, 11, 16, 5),
        ),
      );

      expect(v1.schemaVersion, 1);
      await v1.close();

      final v2 = AppDatabase(NativeDatabase(file));
      addTearDown(v2.close);
      final storeV2 = DriftLocalMediaStore(v2);

      expect(v2.schemaVersion, 2);
      expect(await AppDatabaseMigrations.readSchemaWatermark(v2), '2');

      expect((await storeV2.loadChannels()).single.title, 'News');
      expect((await storeV2.loadVodMetadata()).single.contentId, 'vod-1');
      expect(
        (await storeV2.loadPlaybackProgress('vod-1'))?.position.inMinutes,
        42,
      );
      expect((await storeV2.loadFavorites()).single.contentId, 'ch-1');
      expect((await storeV2.loadSources()).single.sourceId, 'src-1');
      expect((await storeV2.loadSetting('ui.theme'))?.value, 'tv-dark');
      expect((await storeV2.loadOutbox()).single.id, 'ob-1');
    },
  );

  test('TV-015 missing core table throws recoverable schema exception', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    await DriftLocalMediaStore(db).loadSettings();

    await db.customStatement('DROP TABLE favorite_rows');

    await expectLater(
      AppDatabaseMigrations.assertCoreTablesPresent(db),
      throwsA(
        isA<LocalMediaSchemaException>().having(
          (e) => e.message,
          'message',
          contains('favorite_rows'),
        ),
      ),
    );
  });
}
