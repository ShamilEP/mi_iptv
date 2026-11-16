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

/// QA-041 / FR-027 — app update preserves local DB and sync state (US-18).
void main() {
  final sync = SyncMetadata(
    syncVersion: 11,
    updatedAtServer: DateTime.utc(2026, 11, 16, 18),
  );

  group('QA-041 upgrades and migrations', () {
    test(
      'app binary update (v1→current) preserves durable DB and sync state',
      () async {
        final dir = await Directory.systemTemp.createTemp('qa041_upgrade_');
        addTearDown(() => dir.delete(recursive: true));
        final file = File('${dir.path}/mi_iptv_local_media.sqlite');

        final legacy = AppDatabase.legacyV1(NativeDatabase(file));
        final seed = DriftLocalMediaStore(legacy);

        await seed.replaceChannels(const [
          ContentItem(
            contentId: 'ch-news',
            type: ContentType.channel,
            title: 'Signal News',
          ),
        ]);
        await seed.replaceVodMetadata(const [
          ContentItem(
            contentId: 'vod-film',
            type: ContentType.vodMovie,
            title: 'Continue Film',
          ),
        ]);
        await seed.upsertPlaybackProgress(
          PlaybackProgress(
            contentId: 'vod-film',
            position: const Duration(minutes: 17),
            sync: sync,
          ),
        );
        await seed.replaceFavorites([
          FavoriteEntry(
            contentId: 'ch-news',
            contentType: ContentType.channel,
            title: 'Signal News',
            order: 0,
            sync: sync,
          ),
        ]);
        await seed.replaceSources([
          CachedSource(
            sourceId: 'src-m3u',
            kind: 'm3u',
            displayName: 'Home Playlist',
            baseUrl: Uri.parse('https://cdn.example/home.m3u'),
          ),
        ]);
        await seed.upsertSetting(
          const CachedSetting(key: 'player.audio', value: 'default'),
        );
        await seed.enqueueOutbox(
          SyncOutboxEntry(
            id: 'ob-fav-1',
            entityKind: SyncOutboxEntityKind.favorite,
            operation: SyncOutboxOperation.upsert,
            entityId: 'ch-news',
            payloadJson: '{"contentId":"ch-news"}',
            enqueuedAt: DateTime.utc(2026, 11, 16, 18, 5),
          ),
        );

        expect(legacy.schemaVersion, 1);
        await legacy.close();

        // Simulate store binary update: new app opens prior on-disk DB.
        final upgraded = AppDatabase(NativeDatabase(file));
        addTearDown(upgraded.close);
        final store = DriftLocalMediaStore(upgraded);

        expect(
          upgraded.schemaVersion,
          AppDatabaseMigrations.currentSchemaVersion,
        );
        expect(
          await AppDatabaseMigrations.readSchemaWatermark(upgraded),
          '${AppDatabaseMigrations.currentSchemaVersion}',
        );

        expect((await store.loadChannels()).single.title, 'Signal News');
        expect((await store.loadVodMetadata()).single.contentId, 'vod-film');

        final progress = await store.loadPlaybackProgress('vod-film');
        expect(progress?.position, const Duration(minutes: 17));
        expect(progress?.sync.syncVersion, sync.syncVersion);
        expect(
          progress?.sync.updatedAtServer.toUtc(),
          sync.updatedAtServer.toUtc(),
        );

        final favorite = (await store.loadFavorites()).single;
        expect(favorite.contentId, 'ch-news');
        expect(favorite.sync.syncVersion, sync.syncVersion);

        expect((await store.loadSources()).single.sourceId, 'src-m3u');
        expect((await store.loadSetting('player.audio'))?.value, 'default');

        final outbox = (await store.loadOutbox()).single;
        expect(outbox.id, 'ob-fav-1');
        expect(outbox.entityId, 'ch-news');
      },
    );

    test(
      'same-schema reopen after write does not wipe durable or sync state',
      () async {
        final dir = await Directory.systemTemp.createTemp('qa041_reopen_');
        addTearDown(() => dir.delete(recursive: true));
        final file = File('${dir.path}/mi_iptv_local_media.sqlite');

        final first = AppDatabase(NativeDatabase(file));
        final writer = DriftLocalMediaStore(first);
        await writer.replaceFavorites([
          FavoriteEntry(
            contentId: 'ch-keep',
            contentType: ContentType.channel,
            title: 'Keep Me',
            order: 1,
            sync: sync,
          ),
        ]);
        await writer.enqueueOutbox(
          SyncOutboxEntry(
            id: 'ob-keep',
            entityKind: SyncOutboxEntityKind.favorite,
            operation: SyncOutboxOperation.upsert,
            entityId: 'ch-keep',
            payloadJson: '{"contentId":"ch-keep"}',
            enqueuedAt: DateTime.utc(2026, 11, 16, 19),
          ),
        );
        await first.close();

        final second = AppDatabase(NativeDatabase(file));
        addTearDown(second.close);
        final reader = DriftLocalMediaStore(second);

        expect((await reader.loadFavorites()).single.contentId, 'ch-keep');
        expect(
          (await reader.loadFavorites()).single.sync.syncVersion,
          sync.syncVersion,
        );
        expect((await reader.loadOutbox()).single.id, 'ob-keep');
        expect(
          await AppDatabaseMigrations.readSchemaWatermark(second),
          '${AppDatabaseMigrations.currentSchemaVersion}',
        );
      },
    );

    test(
      'corrupt schema surfaces recoverable LocalMediaSchemaException',
      () async {
        final db = AppDatabase(NativeDatabase.memory());
        addTearDown(db.close);
        await DriftLocalMediaStore(db).loadSettings();

        await db.customStatement('DROP TABLE outbox_rows');

        await expectLater(
          AppDatabaseMigrations.assertCoreTablesPresent(db),
          throwsA(
            isA<LocalMediaSchemaException>().having(
              (e) => e.message,
              'message',
              allOf(
                contains('outbox_rows'),
                contains('recover'),
                contains('not wiped silently'),
              ),
            ),
          ),
        );
      },
    );
  });
}
