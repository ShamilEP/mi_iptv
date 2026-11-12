import '../entities/favorite_entry.dart';
import '../entities/playback_progress.dart';

/// Port for multi-device sync payloads shared by TV and Companion.
///
/// Implementations live under `features/sync/data/` (network / cache adapters).
abstract interface class SyncRepository {
  Future<List<FavoriteEntry>> pullFavorites();
  Future<void> pushFavorites(List<FavoriteEntry> entries);

  Future<PlaybackProgress?> pullPlaybackProgress(String contentId);
  Future<void> pushPlaybackProgress(PlaybackProgress progress);
}
