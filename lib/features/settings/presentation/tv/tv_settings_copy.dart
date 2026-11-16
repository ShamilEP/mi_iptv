import '../../../../core/l10n/app_locale.dart';
import '../../../../core/l10n/app_string_catalog.dart';
import '../../../../core/l10n/app_string_key.dart';

/// Locked copy for the TV Settings shell (TV-080 / TV-014).
///
/// Default getters stay English for gallery tests; use [forLocale] under
/// [AppLocaleScope].
abstract final class TvSettingsCopy {
  static String forLocale(AppLocale locale, AppStringKey key) =>
      AppStringCatalog.of(key, locale);

  static String get title =>
      forLocale(AppLocale.en, AppStringKey.settingsTitle);
  static String get account =>
      forLocale(AppLocale.en, AppStringKey.settingsAccount);
  static String get sources =>
      forLocale(AppLocale.en, AppStringKey.settingsSources);
  static String get network =>
      forLocale(AppLocale.en, AppStringKey.settingsNetwork);
  static String get language =>
      forLocale(AppLocale.en, AppStringKey.settingsLanguage);
  static String get playback =>
      forLocale(AppLocale.en, AppStringKey.settingsPlayback);
  static String get currentValues =>
      forLocale(AppLocale.en, AppStringKey.settingsCurrentValues);
  static String get languageBody =>
      forLocale(AppLocale.en, AppStringKey.languageBodyTv);
}
