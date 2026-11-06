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
