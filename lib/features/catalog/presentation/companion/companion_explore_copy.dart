/// Locked copy for Companion Explore and Send-to-TV (DSN-052).
abstract final class CompanionExploreCopy {
  static const String title = 'Explore';
  static const String body =
      'Browse the catalog in showcase mode. Play happens on the TV.';
  static const String sendToTvLabel = 'Reproducir en TV';
  static const String noPlayerNote = 'No video plays on this phone.';
  static const String sentPrefix = 'Sent to TV:';
  static const String featuredTitle = 'Featured';
  static const String liveTitle = 'Live channels';
  static const String moviesTitle = 'Movies';
  static const String favoritesTitle = 'Favorites';
  static const String detailTitle = 'Title details';
  static const String backToCatalogLabel = 'Back to catalog';
  static const String demoTvName = 'Living room';
  static const String syncConflictMessage =
      'Favorites differ on another device. Resolve before sending to TV.';
  static const String offlineCachedBanner =
      'You are offline. Showing cached catalog, favorites, and last TV status.';
}

/// Mandatory Explore surface states from DSN-010 (CMP-045 / CMP-006).
enum CompanionExploreSurfaceState {
  /// Showcase catalog or title detail.
  ready,

  /// Loading catalog.
  loading,

  /// Empty catalog.
  empty,

  /// Load failure.
  error,

  /// No network and no usable cache — full offline pattern.
  offline,

  /// Offline with cached catalog / favorites — banner + rails (CMP-006).
  offlineCached,

  /// Syncing catalog or favorites.
  syncing,

  /// Sync conflict that needs resolve.
  syncConflict,
}
