import 'app_locale.dart';

/// Locale-aware date / number formatting without `package:intl` (CMP-008).
///
/// Patterns follow common regional conventions for EN / ES / zh-CN / FR.
/// Propose `intl` later if ICU completeness is required.
abstract final class LocaleFormats {
  static String formatDate(DateTime date, AppLocale locale) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return switch (locale) {
      AppLocale.en => '$m/$d/$y',
      AppLocale.es => '$d/$m/$y',
      AppLocale.zhCn => '$y/$m/$d',
      AppLocale.fr => '$d/$m/$y',
    };
  }

  static String formatDecimal(num value, AppLocale locale, {int fractionDigits = 2}) {
    final fixed = value.toStringAsFixed(fractionDigits);
    final parts = fixed.split('.');
    final whole = _groupDigits(parts[0], locale);
    if (fractionDigits == 0) return whole;
    final fraction = parts.length > 1 ? parts[1] : ''.padRight(fractionDigits, '0');
    final sep = decimalSeparator(locale);
    return '$whole$sep$fraction';
  }

  static String decimalSeparator(AppLocale locale) => switch (locale) {
        AppLocale.en || AppLocale.zhCn => '.',
        AppLocale.es || AppLocale.fr => ',',
      };

  static String groupSeparator(AppLocale locale) => switch (locale) {
        AppLocale.en || AppLocale.zhCn => ',',
        AppLocale.es => '.',
        AppLocale.fr => ' ',
      };

  static String _groupDigits(String digits, AppLocale locale) {
    final negative = digits.startsWith('-');
    final raw = negative ? digits.substring(1) : digits;
    final sep = groupSeparator(locale);
    final buffer = StringBuffer();
    for (var i = 0; i < raw.length; i++) {
      final fromEnd = raw.length - i;
      if (i > 0 && fromEnd % 3 == 0) {
        buffer.write(sep);
      }
      buffer.write(raw[i]);
    }
    return negative ? '-$buffer' : buffer.toString();
  }
}
