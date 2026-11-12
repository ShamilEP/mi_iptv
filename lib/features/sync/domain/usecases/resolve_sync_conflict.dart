import '../entities/favorite_entry.dart';
import '../entities/playback_progress.dart';
import '../entities/sync_metadata.dart';

/// Deterministic multi-device conflict rules (US-22 / TV-005).
///
/// Default policy: last-write-wins on **server** time, then [SyncMetadata.syncVersion].
/// Playback progress inside [playbackShortWindow] prefers the higher
/// [PlaybackProgress.position] unless [PlaybackProgress.forceReset] applies.
final class ResolveSyncConflict {
  const ResolveSyncConflict({
    this.playbackShortWindow = defaultPlaybackShortWindow,
  });

  /// Sprint 0 tunable default; Product may change the window without changing rules.
  static const Duration defaultPlaybackShortWindow = Duration(seconds: 30);

  final Duration playbackShortWindow;

  /// Generic LWW on server clock, then syncVersion (never device clock).
  SyncMetadata pickMetadata(SyncMetadata a, SyncMetadata b) {
    return _metadataAWins(a, b) ? a : b;
  }

  FavoriteEntry resolveFavorite(FavoriteEntry local, FavoriteEntry remote) {
    if (local.contentId != remote.contentId) {
      throw ArgumentError('FavoriteEntry contentId mismatch');
    }
    return _metadataAWins(local.sync, remote.sync) ? local : remote;
  }

  PlaybackProgress resolvePlaybackProgress(
    PlaybackProgress local,
    PlaybackProgress remote,
  ) {
    if (local.contentId != remote.contentId) {
      throw ArgumentError('PlaybackProgress contentId mismatch');
    }

    final delta =
        local.sync.updatedAtServer.difference(remote.sync.updatedAtServer).abs();
    final inShortWindow = delta <= playbackShortWindow;

    if (inShortWindow) {
      if (local.forceReset != remote.forceReset) {
        return local.forceReset ? local : remote;
      }
      if (local.position != remote.position) {
        return local.position > remote.position ? local : remote;
      }
    }

    return _metadataAWins(local.sync, remote.sync) ? local : remote;
  }

  bool _metadataAWins(SyncMetadata a, SyncMetadata b) {
    final byTime = a.updatedAtServer.compareTo(b.updatedAtServer);
    if (byTime != 0) return byTime > 0;
    return a.syncVersion >= b.syncVersion;
  }
}
