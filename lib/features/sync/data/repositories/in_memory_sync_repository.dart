import '../../domain/entities/favorite_entry.dart';
import '../../domain/entities/playback_progress.dart';
import '../../domain/repositories/sync_repository.dart';
import '../../domain/usecases/resolve_sync_conflict.dart';

/// Process-local sync store for Sprint 0 wiring (TV + Companion share the type).
///
/// Not durable — persistence adapters replace this in TV-007 / CMP-006.
final class InMemorySyncRepository implements SyncRepository {
  InMemorySyncRepository({ResolveSyncConflict? conflictResolver})
      : _conflicts = conflictResolver ?? const ResolveSyncConflict();

  final ResolveSyncConflict _conflicts;
  final Map<String, FavoriteEntry> _favorites = <String, FavoriteEntry>{};
  final Map<String, PlaybackProgress> _playback = <String, PlaybackProgress>{};

  @override
  Future<List<FavoriteEntry>> pullFavorites() async {
    final values = _favorites.values.toList(growable: false)
      ..sort((a, b) => a.order.compareTo(b.order));
    return List<FavoriteEntry>.unmodifiable(values);
  }

  @override
  Future<void> pushFavorites(List<FavoriteEntry> entries) async {
    for (final incoming in entries) {
      final existing = _favorites[incoming.contentId];
      _favorites[incoming.contentId] = existing == null
          ? incoming
          : _conflicts.resolveFavorite(existing, incoming);
    }
  }

  @override
  Future<PlaybackProgress?> pullPlaybackProgress(String contentId) async {
    return _playback[contentId];
  }

  @override
  Future<void> pushPlaybackProgress(PlaybackProgress progress) async {
    final existing = _playback[progress.contentId];
    _playback[progress.contentId] = existing == null
        ? progress
        : _conflicts.resolvePlaybackProgress(existing, progress);
  }
}
