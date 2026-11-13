import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/l10n/app_locale.dart';
import 'package:mi_iptv/core/l10n/app_string_catalog.dart';
import 'package:mi_iptv/core/l10n/app_string_key.dart';

void main() {
  test('CMP-008 catalogs cover EN, ES, zh-CN, FR explore titles', () {
    expect(
      AppStringCatalog.of(AppStringKey.exploreTitle, AppLocale.en),
      'Explore',
    );
    expect(
      AppStringCatalog.of(AppStringKey.exploreTitle, AppLocale.es),
      'Explorar',
    );
    expect(
      AppStringCatalog.of(AppStringKey.exploreTitle, AppLocale.zhCn),
      '浏览',
    );
    expect(
      AppStringCatalog.of(AppStringKey.exploreTitle, AppLocale.fr),
      'Explorer',
    );
  });

  test('CMP-008 AppLocale.parse accepts PRD-012 tags', () {
    expect(AppLocale.parse('en'), AppLocale.en);
    expect(AppLocale.parse('es-ES'), AppLocale.es);
    expect(AppLocale.parse('zh-CN'), AppLocale.zhCn);
    expect(AppLocale.parse('zh_CN'), AppLocale.zhCn);
    expect(AppLocale.parse('fr'), AppLocale.fr);
    expect(AppLocale.parse('unknown'), AppLocale.en);
  });
}
