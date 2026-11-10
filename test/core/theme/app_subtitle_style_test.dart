import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/accessibility/tv_accessibility.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/core/widgets/mi_subtitle_caption.dart';
import 'package:mi_iptv/features/player/presentation/tv/tv_vod_player_page.dart';

void main() {
  group('AppSubtitleStyle DSN-021', () {
    test('locks standard and large sizes', () {
      expect(AppSubtitleStyle.standardFontSize, 32);
      expect(AppSubtitleStyle.largeFontSize, 40);
      expect(AppSubtitleStyle.fontSizeOf(SubtitleSizePreset.standard), 32);
      expect(AppSubtitleStyle.fontSizeOf(SubtitleSizePreset.large), 40);
      expect(AppSubtitleStyle.backgroundOpacity, 0.72);
      expect(AppSubtitleStyle.foreground, AppColors.cloud);
    });

    test('Cloud on Ink meets large-text WCAG AA', () {
      expect(AppSubtitleStyle.contrastMeetsAa(), isTrue);
      expect(
        ColorContrast.meetsWcagAa(
          AppSubtitleStyle.foreground,
          AppColors.ink,
          largeText: true,
        ),
        isTrue,
      );
    });
  });

  group('TvAccessibility', () {
    test('clamps OS text scale into 1.0–1.5', () {
      final low = TvAccessibility.clampTextScaler(const TextScaler.linear(0.8));
      final high = TvAccessibility.clampTextScaler(const TextScaler.linear(2.0));
      final mid = TvAccessibility.clampTextScaler(const TextScaler.linear(1.25));

      expect(low.scale(10), 10);
      expect(high.scale(10), 15);
      expect(mid.scale(10), 12.5);
    });
  });

  testWidgets('MiSubtitleCaption paints scrim and text', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.tvDark(),
        home: const Scaffold(
          body: Center(
            child: MiSubtitleCaption(text: 'Hello harbor'),
          ),
        ),
      ),
    );

    expect(find.text('Hello harbor'), findsOneWidget);
    final box = tester.widget<DecoratedBox>(find.byType(DecoratedBox).first);
    final decoration = box.decoration as BoxDecoration;
    expect(decoration.color, AppSubtitleStyle.background);
  });

  testWidgets('VOD page shows caption under TvAccessibleScope', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1920, 1080));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2.0)),
        child: MaterialApp(
          theme: AppTheme.tvDark(),
          home: const TvVodPlayerPage(autoHide: false),
        ),
      ),
    );
    await tester.pump();

    expect(find.text(TvVodPlayerPage.demoSubtitle), findsOneWidget);
    expect(find.byKey(const ValueKey('vod-subtitle')), findsOneWidget);

    final scope = tester.widget<MediaQuery>(
      find
          .descendant(
            of: find.byType(TvAccessibleScope),
            matching: find.byType(MediaQuery),
          )
          .first,
    );
    expect(scope.data.textScaler.scale(10), 15);
  });

  testWidgets('large subtitle preset uses larger font', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.tvDark(),
        home: const Scaffold(
          body: MiSubtitleCaption(
            text: 'Large line',
            size: SubtitleSizePreset.large,
          ),
        ),
      ),
    );

    final text = tester.widget<Text>(find.text('Large line'));
    expect(text.style?.fontSize, AppSubtitleStyle.largeFontSize);
  });
}
