import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/l10n/app_locale.dart';
import 'package:mi_iptv/core/l10n/locale_formats.dart';

void main() {
  test('CMP-008 date formats differ by locale', () {
    final date = DateTime(2026, 11, 13);
    expect(LocaleFormats.formatDate(date, AppLocale.en), '11/13/2026');
    expect(LocaleFormats.formatDate(date, AppLocale.es), '13/11/2026');
    expect(LocaleFormats.formatDate(date, AppLocale.zhCn), '2026/11/13');
    expect(LocaleFormats.formatDate(date, AppLocale.fr), '13/11/2026');
  });

  test('CMP-008 decimal formats use regional separators', () {
    expect(LocaleFormats.formatDecimal(1234.56, AppLocale.en), '1,234.56');
    expect(LocaleFormats.formatDecimal(1234.56, AppLocale.es), '1.234,56');
    expect(LocaleFormats.formatDecimal(1234.56, AppLocale.zhCn), '1,234.56');
    expect(LocaleFormats.formatDecimal(1234.56, AppLocale.fr), '1 234,56');
  });
}
