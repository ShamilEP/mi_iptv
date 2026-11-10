import 'ui_state.dart';

/// Default actionable copy for empty / error / offline patterns (DSN-017).
class StatusPatternCopy {
  const StatusPatternCopy({
    required this.title,
    required this.message,
    required this.actionLabel,
  });

  final String title;
  final String message;
  final String actionLabel;

  /// Tracker DoD example — empty Favorites.
  static const StatusPatternCopy favoritesEmpty = StatusPatternCopy(
    title: 'No hay favoritos',
    message: 'Save shows and channels here for quick access on any device.',
    actionLabel: 'Browse catalog',
  );

  static const StatusPatternCopy genericEmpty = StatusPatternCopy(
    title: 'Nothing here yet',
    message: 'When content arrives, it will show up in this list.',
    actionLabel: 'Refresh',
  );

  static const StatusPatternCopy genericError = StatusPatternCopy(
    title: 'Something went wrong',
    message: 'We could not load this screen. Try again in a moment.',
    actionLabel: 'Retry',
  );

  static const StatusPatternCopy genericOffline = StatusPatternCopy(
    title: 'You are offline',
    message: 'Reconnect to continue browsing. Cached items stay available when labeled.',
    actionLabel: 'Try again',
  );

  /// Companion Explore empty catalog (CMP-045).
  static const StatusPatternCopy exploreEmpty = StatusPatternCopy(
    title: 'No titles to explore',
    message: 'When catalog items sync, they will appear here for Send-to-TV.',
    actionLabel: 'Refresh',
  );

  /// TV Home — no sources configured (TV-033).
  static const StatusPatternCopy homeNoSources = StatusPatternCopy(
    title: 'No sources',
    message:
        'Add an M3U or Xtream source to fill Home with channels and titles.',
    actionLabel: 'Add source',
  );

  /// TV Home — sources linked but catalog empty (TV-033).
  static const StatusPatternCopy homeEmptyCatalog = StatusPatternCopy(
    title: 'Catalog is empty',
    message:
        'Sources are linked, but nothing synced yet. Refresh or check the source.',
    actionLabel: 'Refresh',
  );

  /// TV Home — offline (TV-033).
  static const StatusPatternCopy homeOffline = StatusPatternCopy(
    title: 'You are offline',
    message:
        'Reconnect to load Home. Cached rails stay available when labeled.',
    actionLabel: 'Try again',
  );

  static StatusPatternCopy defaultsFor(UiState state) {
    switch (state) {
      case UiState.empty:
        return genericEmpty;
      case UiState.error:
        return genericError;
      case UiState.offline:
        return genericOffline;
      default:
        return genericEmpty;
    }
  }
}
