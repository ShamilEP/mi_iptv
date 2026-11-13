import 'package:flutter/widgets.dart';

import 'app_locale.dart';
import 'app_string_catalog.dart';
import 'app_string_key.dart';
import 'locale_controller.dart';
import 'locale_formats.dart';

/// Provides [LocaleController] to the Companion tree (CMP-008).
class AppLocaleScope extends InheritedNotifier<LocaleController> {
  const AppLocaleScope({
    super.key,
    required LocaleController controller,
    required super.child,
  }) : super(notifier: controller);

  static LocaleController controllerOf(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<AppLocaleScope>();
    assert(scope != null, 'AppLocaleScope not found in context');
    return scope!.notifier!;
  }

  static AppLocale localeOf(BuildContext context) =>
      controllerOf(context).locale;

  static String stringOf(BuildContext context, AppStringKey key) {
    return AppStringCatalog.of(key, localeOf(context));
  }

  static String formatDate(BuildContext context, DateTime date) {
    return LocaleFormats.formatDate(date, localeOf(context));
  }

  static String formatDecimal(
    BuildContext context,
    num value, {
    int fractionDigits = 2,
  }) {
    return LocaleFormats.formatDecimal(
      value,
      localeOf(context),
      fractionDigits: fractionDigits,
    );
  }
}
