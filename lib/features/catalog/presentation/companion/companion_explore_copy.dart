import '../../../../core/l10n/app_locale.dart';
import '../../../../core/l10n/app_string_catalog.dart';
import '../../../../core/l10n/app_string_key.dart';

/// Locked copy for Companion Explore and Send-to-TV (DSN-052 / CMP-008).
///
/// Default getters stay English for gallery tests; use [forLocale] under
/// [AppLocaleScope].
abstract final class CompanionExploreCopy {
  static String forLocale(AppLocale locale, AppStringKey key) =>
      AppStringCatalog.of(key, locale);

  static String get title =>
      forLocale(AppLocale.en, AppStringKey.exploreTitle);
  static String get body => forLocale(AppLocale.en, AppStringKey.exploreBody);
  static String get sendToTvLabel =>
      forLocale(AppLocale.es, AppStringKey.exploreSendToTv);
  static String get noPlayerNote =>
      forLocale(AppLocale.en, AppStringKey.exploreNoPlayerNote);
  static const String sentPrefix = 'Sent to TV:';
  static String get featuredTitle =>
      forLocale(AppLocale.en, AppStringKey.exploreFeatured);
  static String get liveTitle =>
      forLocale(AppLocale.en, AppStringKey.exploreLive);
  static String get moviesTitle =>
      forLocale(AppLocale.en, AppStringKey.exploreMovies);
  static String get favoritesTitle =>
      forLocale(AppLocale.en, AppStringKey.exploreFavorites);
  static String get detailTitle =>
      forLocale(AppLocale.en, AppStringKey.exploreDetailTitle);
  static String get backToCatalogLabel =>
      forLocale(AppLocale.en, AppStringKey.exploreBackToCatalog);
  static const String demoTvName = 'Living room';
  static String get syncConflictMessage =>
      forLocale(AppLocale.en, AppStringKey.exploreSyncConflict);
  static String get offlineCachedBanner =>
      forLocale(AppLocale.en, AppStringKey.exploreOfflineCachedBanner);
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
