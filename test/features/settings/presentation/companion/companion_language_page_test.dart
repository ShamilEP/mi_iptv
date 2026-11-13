import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/l10n/app_locale.dart';
import 'package:mi_iptv/core/l10n/app_locale_scope.dart';
import 'package:mi_iptv/core/l10n/app_string_catalog.dart';
import 'package:mi_iptv/core/l10n/app_string_key.dart';
import 'package:mi_iptv/core/l10n/locale_controller.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/features/settings/presentation/companion/companion_language_page.dart';

void main() {
  testWidgets('CMP-008 language page switches strings and formats', (
    tester,
  ) async {
    final controller = LocaleController(initial: AppLocale.en);
    final sampleDate = DateTime(2026, 11, 13);

    await tester.binding.setSurfaceSize(const Size(390, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      AppLocaleScope(
        controller: controller,
        child: MaterialApp(
          theme: AppTheme.companionLight(),
          home: CompanionLanguagePage(sampleDate: sampleDate),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text(AppStringCatalog.of(AppStringKey.languageTitle, AppLocale.en)),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey<String>('locale-date-sample')), findsOneWidget);
    expect(find.text('11/13/2026'), findsOneWidget);
    expect(find.text('1,234.56'), findsOneWidget);

    await tester.tap(find.text(AppLocale.es.displayName));
    await tester.pumpAndSettle();

    expect(
      find.text(AppStringCatalog.of(AppStringKey.languageTitle, AppLocale.es)),
      findsOneWidget,
    );
    expect(find.text('13/11/2026'), findsOneWidget);
    expect(find.text('1.234,56'), findsOneWidget);
    expect(controller.locale, AppLocale.es);
  });
}
