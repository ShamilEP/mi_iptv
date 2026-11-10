import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/accessibility/tv_accessibility.dart';
import 'package:mi_iptv/core/accessibility/tv_distance_legibility.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/features/home/presentation/tv/tv_home_page.dart';

void main() {
  group('TV-123 accessibility pass policy', () {
    test('clamps OS text scale into 1.0–1.5', () {
      final low = TvAccessibility.clampTextScaler(const TextScaler.linear(0.8));
      final high = TvAccessibility.clampTextScaler(const TextScaler.linear(2.0));
      final mid = TvAccessibility.clampTextScaler(const TextScaler.linear(1.25));

      expect(low.scale(100), 100);
      expect(high.scale(100), 150);
      expect(mid.scale(100), 125);
      expect(TvAccessibility.minTextScale, 1.0);
      expect(TvAccessibility.maxTextScale, 1.5);
    });

    test('text sizes meet 2–3 m floors', () {
      expect(TvAccessibility.minViewingDistanceMeters, 2.0);
      expect(TvAccessibility.maxViewingDistanceMeters, 3.0);
      expect(TvAccessibility.textSizesMeetDistanceFloors(), isTrue);
      expect(AppTypography.tvBodySize, greaterThanOrEqualTo(20));
      expect(AppTypography.tvTitleSize, greaterThanOrEqualTo(28));
    });

    test('contrast pairs meet WCAG AA at distance', () {
      expect(TvAccessibility.contrastChecks, isNotEmpty);
      expect(TvAccessibility.contrastPassesAa(), isTrue);
      for (final check in TvAccessibility.contrastChecks) {
        expect(
          ColorContrast.meetsWcagAa(check.foreground, check.background),
          isTrue,
          reason: check.role,
        );
      }
    });

    test('focus visibility and subtitles pass', () {
      expect(TvAccessibility.focusVisibleAtDistance(), isTrue);
      expect(TvAccessibility.subtitlesMeetAccessibility(), isTrue);
      expect(AppSubtitleStyle.standardFontSize, greaterThanOrEqualTo(20));
      expect(AppSubtitleStyle.contrastMeetsAa(), isTrue);
    });

    test('aggregate accessibility pass gate is green', () {
      expect(TvAccessibility.passesAccessibilityPass(), isTrue);
      expect(TvDistanceLegibility.passesDistanceAccessibility(), isTrue);
    });
  });

  testWidgets('Home honors TvAccessibleScope text clamp at 2.0× request', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1920, 1080));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2.0)),
        child: MaterialApp(
          theme: AppTheme.tvDark(),
          home: const TvHomePage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(TvAccessibleScope), findsOneWidget);
    expect(find.text(TvHomePage.continueWatchingTitle), findsOneWidget);

    final media = tester.widget<MediaQuery>(
      find
          .descendant(
            of: find.byType(TvAccessibleScope),
            matching: find.byType(MediaQuery),
          )
          .first,
    );
    expect(media.data.textScaler.scale(100), 150);
  });
}
