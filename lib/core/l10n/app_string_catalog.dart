import 'app_locale.dart';
import 'app_string_key.dart';
import 'translations/strings_en.dart';
import 'translations/strings_es.dart';
import 'translations/strings_fr.dart';
import 'translations/strings_zh_cn.dart';

/// Locale → string table (CMP-008). No codegen / no new packages.
abstract final class AppStringCatalog {
  static String of(AppStringKey key, AppLocale locale) {
    final table = _tableFor(locale);
    return table[key] ?? stringsEn[key] ?? key.name;
  }

  static Map<AppStringKey, String> _tableFor(AppLocale locale) {
    return switch (locale) {
      AppLocale.en => stringsEn,
      AppLocale.es => stringsEs,
      AppLocale.zhCn => stringsZhCn,
      AppLocale.fr => stringsFr,
    };
  }
}
