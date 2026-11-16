import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/l10n/app_locale.dart';
import 'package:mi_iptv/core/l10n/app_locale_scope.dart';
import 'package:mi_iptv/core/l10n/app_string_catalog.dart';
import 'package:mi_iptv/core/l10n/app_string_key.dart';
import 'package:mi_iptv/core/l10n/locale_controller.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/features/settings/presentation/tv/tv_language_panel.dart';
import 'package:mi_iptv/features/settings/presentation/tv/tv_settings_models.dart';
import 'package:mi_iptv/features/settings/presentation/tv/tv_settings_page.dart';

void main() {
  testWidgets('TV-014 language panel switches strings and formats', (
    tester,
  ) async {
    final controller = LocaleController(initial: AppLocale.en);
    final sampleDate = DateTime(2026, 11, 13);

    await tester.binding.setSurfaceSize(const Size(1920, 1080));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      AppLocaleScope(
        controller: controller,
        child: MaterialApp(
          theme: AppTheme.tvDark(),
          home: Scaffold(
            body: TvLanguagePanel(
              sampleDate: sampleDate,
              extraValues: const <TvSettingsValue>[
                TvSettingsValue(label: 'Subtitles', value: 'Off'),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text(
        AppStringCatalog.of(AppStringKey.settingsLanguage, AppLocale.en),
      ),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey<String>('tv-locale-date-sample')), findsOneWidget);
    expect(find.text('11/13/2026'), findsOneWidget);
    expect(find.text('1,234.56'), findsOneWidget);
    expect(find.text('Subtitles'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey<String>('tv-locale-es')));
    await tester.pumpAndSettle();

    expect(
      find.text(
        AppStringCatalog.of(AppStringKey.settingsLanguage, AppLocale.es),
      ),
      findsOneWidget,
    );
    expect(find.text('13/11/2026'), findsOneWidget);
    expect(find.text('1.234,56'), findsOneWidget);
    expect(controller.locale, AppLocale.es);
  });

  testWidgets('TV-014 Settings Language category hosts language panel', (
    tester,
  ) async {
    final controller = LocaleController(initial: AppLocale.en);

    await tester.binding.setSurfaceSize(const Size(1920, 1080));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      AppLocaleScope(
        controller: controller,
        child: MaterialApp(
          theme: AppTheme.tvDark(),
          home: const TvSettingsPage(
            initialCategory: TvSettingsCategory.language,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(TvLanguagePanel), findsOneWidget);
    expect(find.byKey(const ValueKey<String>('tv-locale-en')), findsOneWidget);
    expect(find.text(AppLocale.en.displayName), findsWidgets);

    await tester.tap(find.byKey(const ValueKey<String>('tv-locale-fr')));
    await tester.pumpAndSettle();

    expect(controller.locale, AppLocale.fr);
    expect(
      find.text(
        AppStringCatalog.of(AppStringKey.settingsTitle, AppLocale.fr),
      ),
      findsOneWidget,
    );
  });
}
