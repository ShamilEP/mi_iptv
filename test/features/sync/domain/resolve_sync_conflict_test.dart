import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/features/catalog/domain/entities/content_item.dart';
import 'package:mi_iptv/features/sync/domain/entities/favorite_entry.dart';
import 'package:mi_iptv/features/sync/domain/entities/playback_progress.dart';
import 'package:mi_iptv/features/sync/domain/entities/sync_metadata.dart';
import 'package:mi_iptv/features/sync/domain/usecases/resolve_sync_conflict.dart';

void main() {
  const resolver = ResolveSyncConflict();
  final t0 = DateTime.utc(2026, 11, 12, 12);
  final t1 = t0.add(const Duration(seconds: 10));
  final tFar = t0.add(const Duration(minutes: 5));

  group('ResolveSyncConflict favorites LWW', () {
    test('newer server time wins', () {
      final local = FavoriteEntry(
        contentId: 'ch-12',
        contentType: ContentType.channel,
        title: 'Local',
        order: 1,
        sync: SyncMetadata(syncVersion: 1, updatedAtServer: t0),
      );
      final remote = FavoriteEntry(
        contentId: 'ch-12',
        contentType: ContentType.channel,
        title: 'Remote',
        order: 2,
        sync: SyncMetadata(syncVersion: 1, updatedAtServer: t1),
      );

      expect(resolver.resolveFavorite(local, remote).title, 'Remote');
    });

    test('equal time uses higher syncVersion', () {
      final local = FavoriteEntry(
        contentId: 'ch-12',
        contentType: ContentType.channel,
        title: 'Local',
        order: 1,
        sync: SyncMetadata(syncVersion: 3, updatedAtServer: t0),
      );
      final remote = FavoriteEntry(
        contentId: 'ch-12',
        contentType: ContentType.channel,
        title: 'Remote',
        order: 2,
        sync: SyncMetadata(syncVersion: 2, updatedAtServer: t0),
      );

      expect(resolver.resolveFavorite(local, remote).title, 'Local');
    });
  });

  group('ResolveSyncConflict playback', () {
    test('short window prefers higher position', () {
      final local = PlaybackProgress(
        contentId: 'vod-1',
        position: const Duration(minutes: 12),
        sync: SyncMetadata(syncVersion: 1, updatedAtServer: t0),
      );
      final remote = PlaybackProgress(
        contentId: 'vod-1',
        position: const Duration(minutes: 20),
        sync: SyncMetadata(syncVersion: 9, updatedAtServer: t1),
      );

      expect(
        resolver.resolvePlaybackProgress(local, remote).position,
        const Duration(minutes: 20),
      );
    });

    test('forceReset wins inside short window over higher position', () {
      final local = PlaybackProgress(
        contentId: 'vod-1',
        position: Duration.zero,
        forceReset: true,
        sync: SyncMetadata(syncVersion: 1, updatedAtServer: t0),
      );
      final remote = PlaybackProgress(
        contentId: 'vod-1',
        position: const Duration(minutes: 40),
        sync: SyncMetadata(syncVersion: 5, updatedAtServer: t1),
      );

      expect(
        resolver.resolvePlaybackProgress(local, remote).forceReset,
        isTrue,
      );
      expect(
        resolver.resolvePlaybackProgress(local, remote).position,
        Duration.zero,
      );
    });

    test('outside short window uses LWW metadata', () {
      final local = PlaybackProgress(
        contentId: 'vod-1',
        position: const Duration(minutes: 50),
        sync: SyncMetadata(syncVersion: 1, updatedAtServer: t0),
      );
      final remote = PlaybackProgress(
        contentId: 'vod-1',
        position: const Duration(minutes: 1),
        sync: SyncMetadata(syncVersion: 2, updatedAtServer: tFar),
      );

      expect(
        resolver.resolvePlaybackProgress(local, remote).position,
        const Duration(minutes: 1),
      );
    });
  });
}
