import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/l10n/app_locale.dart';
import 'package:mi_iptv/core/l10n/app_locale_scope.dart';
import 'package:mi_iptv/core/l10n/app_string_catalog.dart';
import 'package:mi_iptv/core/l10n/app_string_key.dart';
import 'package:mi_iptv/core/l10n/locale_controller.dart';
import 'package:mi_iptv/core/l10n/locale_formats.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/core/widgets/content_card.dart';
import 'package:mi_iptv/core/widgets/mi_button.dart';
import 'package:mi_iptv/features/settings/presentation/companion/companion_language_page.dart';
import 'package:mi_iptv/features/settings/presentation/tv/tv_language_panel.dart';

/// QA-040 / NFR-012 — string overflow + locale formats (depends TV-014).
void main() {
  group('QA-040 localization', () {
    test('every AppStringKey is non-empty for EN/ES/zh-CN/FR', () {
      for (final locale in AppLocale.supported) {
        for (final key in AppStringKey.values) {
          final value = AppStringCatalog.of(key, locale);
          expect(
            value.trim(),
            isNotEmpty,
            reason: '$key / ${locale.languageTag}',
          );
          expect(
            value,
            isNot(key.name),
            reason: 'bare key fallback for $key / ${locale.languageTag}',
          );
        }
      }
    });

    test('locale date and decimal formats match regional conventions', () {
      final date = DateTime(2026, 11, 13);
      const value = 1234.56;

      expect(LocaleFormats.formatDate(date, AppLocale.en), '11/13/2026');
      expect(LocaleFormats.formatDate(date, AppLocale.es), '13/11/2026');
      expect(LocaleFormats.formatDate(date, AppLocale.zhCn), '2026/11/13');
      expect(LocaleFormats.formatDate(date, AppLocale.fr), '13/11/2026');

      expect(LocaleFormats.formatDecimal(value, AppLocale.en), '1,234.56');
      expect(LocaleFormats.formatDecimal(value, AppLocale.es), '1.234,56');
      expect(LocaleFormats.formatDecimal(value, AppLocale.zhCn), '1,234.56');
      expect(LocaleFormats.formatDecimal(value, AppLocale.fr), '1 234,56');
    });

    testWidgets('TV + Companion language surfaces show locale formats', (
      tester,
    ) async {
      final sampleDate = DateTime(2026, 11, 13);

      for (final locale in AppLocale.supported) {
        final expectedDate = LocaleFormats.formatDate(sampleDate, locale);
        final expectedNumber = LocaleFormats.formatDecimal(1234.56, locale);
        final controller = LocaleController(initial: locale);

        await tester.binding.setSurfaceSize(const Size(1280, 720));
        await tester.pumpWidget(
          AppLocaleScope(
            controller: controller,
            child: MaterialApp(
              theme: AppTheme.tvDark(),
              home: Scaffold(
                body: SingleChildScrollView(
                  child: TvLanguagePanel(sampleDate: sampleDate),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(
          tester.widget<Text>(
            find.byKey(const ValueKey<String>('tv-locale-date-sample')),
          ).data,
          expectedDate,
          reason: 'TV date ${locale.languageTag}',
        );
        expect(
          tester.widget<Text>(
            find.byKey(const ValueKey<String>('tv-locale-number-sample')),
          ).data,
          expectedNumber,
          reason: 'TV number ${locale.languageTag}',
        );
        expect(tester.takeException(), isNull);

        await tester.binding.setSurfaceSize(const Size(390, 1200));
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
          tester.widget<Text>(
            find.byKey(const ValueKey<String>('locale-date-sample')),
          ).data,
          expectedDate,
          reason: 'Companion date ${locale.languageTag}',
        );
        expect(
          tester.widget<Text>(
            find.byKey(const ValueKey<String>('locale-number-sample')),
          ).data,
          expectedNumber,
          reason: 'Companion number ${locale.languageTag}',
        );
        expect(tester.takeException(), isNull);
      }

      await tester.binding.setSurfaceSize(null);
    });

    testWidgets(
      'long catalog strings and titles ellipsize without layout overflow',
      (tester) async {
        const adversarial =
            'WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW';
        final longBodies = <String>[
          for (final locale in AppLocale.supported)
            AppStringCatalog.of(AppStringKey.exploreOfflineCachedBanner, locale),
          for (final locale in AppLocale.supported)
            AppStringCatalog.of(AppStringKey.languageBodyTv, locale),
          adversarial,
        ];

        final overflows = <String>[];
        final previous = FlutterError.onError;
        FlutterError.onError = (details) {
          final text = details.exceptionAsString();
          if (text.contains('overflowed') || text.contains('OVERFLOWING')) {
            overflows.add(text);
            return;
          }
          previous?.call(details);
        };
        addTearDown(() => FlutterError.onError = previous);

        await tester.binding.setSurfaceSize(const Size(1280, 720));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        for (final label in longBodies) {
          await tester.pumpWidget(
            MaterialApp(
              theme: AppTheme.tvDark(),
              home: Scaffold(
                backgroundColor: AppColors.ink,
                body: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 160,
                        child: ContentCard(
                          kind: ContentCardKind.poster,
                          title: label,
                          subtitle: label,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      SizedBox(
                        width: 120,
                        child: MiButton(label: label, onPressed: () {}),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();

          expect(tester.takeException(), isNull, reason: label);
          expect(find.byType(ContentCard), findsOneWidget);
          expect(find.byType(MiButton), findsOneWidget);

          final titleText = tester.widgetList<Text>(find.byType(Text)).where(
            (t) => t.data == label || (t.data?.startsWith('W') ?? false),
          );
          for (final text in titleText) {
            expect(
              text.overflow,
              TextOverflow.ellipsis,
              reason: 'ellipsis required for constrained copy',
            );
          }
        }

        expect(overflows, isEmpty, reason: overflows.join('\n---\n'));
      },
    );
  });
}
