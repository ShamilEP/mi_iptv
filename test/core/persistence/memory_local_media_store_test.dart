import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/persistence/memory_local_media_store.dart';
import 'package:mi_iptv/features/catalog/domain/entities/content_item.dart';
import 'package:mi_iptv/features/settings/domain/entities/cached_setting.dart';
import 'package:mi_iptv/features/sources/domain/entities/cached_source.dart';
import 'package:mi_iptv/features/sync/domain/entities/favorite_entry.dart';
import 'package:mi_iptv/features/sync/domain/entities/playback_progress.dart';
import 'package:mi_iptv/features/sync/domain/entities/sync_metadata.dart';
import 'package:mi_iptv/features/sync/domain/entities/sync_outbox_entry.dart';

void main() {
  late MemoryLocalMediaStore store;

  setUp(() {
    store = MemoryLocalMediaStore();
  });

  final sync = SyncMetadata(
    syncVersion: 1,
    updatedAtServer: DateTime.utc(2026, 11, 12),
  );

  test('caches channels and VOD metadata separately', () async {
    await store.replaceChannels(const [
      ContentItem(
        contentId: 'ch-1',
        type: ContentType.channel,
        title: 'News',
      ),
      ContentItem(
        contentId: 'vod-skip',
        type: ContentType.vodMovie,
        title: 'Should not land in channels',
      ),
    ]);
    await store.replaceVodMetadata(const [
      ContentItem(
        contentId: 'vod-1',
        type: ContentType.vodMovie,
        title: 'Film',
      ),
    ]);

    expect((await store.loadChannels()).single.contentId, 'ch-1');
    expect((await store.loadVodMetadata()).single.contentId, 'vod-1');
  });

  test('persists playback, favorites, sources, settings, and outbox', () async {
    await store.upsertPlaybackProgress(
      PlaybackProgress(
        contentId: 'vod-1',
        position: const Duration(minutes: 3),
        sync: sync,
      ),
    );
    await store.replaceFavorites([
      FavoriteEntry(
        contentId: 'ch-1',
        contentType: ContentType.channel,
        title: 'News',
        order: 1,
        sync: sync,
      ),
    ]);
    await store.replaceSources(const [
      CachedSource(
        sourceId: 'src-1',
        kind: 'm3u',
        displayName: 'Home list',
      ),
    ]);
    await store.upsertSetting(
      const CachedSetting(key: 'audio.lang', value: 'en'),
    );
    await store.enqueueOutbox(
      SyncOutboxEntry(
        id: 'ob-1',
        entityKind: SyncOutboxEntityKind.favorite,
        operation: SyncOutboxOperation.upsert,
        entityId: 'ch-1',
        payloadJson: '{"contentId":"ch-1"}',
        enqueuedAt: DateTime.utc(2026, 11, 12, 1),
      ),
    );

    expect((await store.loadPlaybackProgress('vod-1'))?.position.inMinutes, 3);
    expect((await store.loadFavorites()).single.title, 'News');
    expect((await store.loadSources()).single.kind, 'm3u');
    expect((await store.loadSetting('audio.lang'))?.value, 'en');
    expect((await store.loadOutbox()).single.id, 'ob-1');

    await store.removeOutbox('ob-1');
    expect(await store.loadOutbox(), isEmpty);
  });

  test('CachedSource type has no password fields', () {
    const source = CachedSource(
      sourceId: 's',
      kind: 'xtream',
      displayName: 'Provider',
    );
    expect(source.toString(), isNot(contains('password')));
    expect(source.toString(), isNot(contains('token')));
  });
}
