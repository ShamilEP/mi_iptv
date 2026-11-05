import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/app/app.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/core/widgets/content_card.dart';
import 'package:mi_iptv/core/widgets/focusable_surface.dart';

void main() {
  group('ContentCardMetrics DSN-011', () {
    test('locks aspects and default widths for every kind', () {
      expect(ContentCardMetrics.posterAspect, closeTo(2 / 3, 0.0001));
      expect(ContentCardMetrics.landscapeAspect, closeTo(16 / 9, 0.0001));
      expect(ContentCardMetrics.channelTileAspect, 1);
      expect(
        ContentCardMetrics.continueWatchingAspect,
        ContentCardMetrics.landscapeAspect,
      );
      expect(ContentCardMetrics.progressTrackHeight, FocusStyles.ringWidth);

      expect(
        ContentCardMetrics.sizeOf(ContentCardKind.poster),
        const Size(160, 240),
      );
      expect(
        ContentCardMetrics.sizeOf(ContentCardKind.landscape).aspectRatio,
        closeTo(16 / 9, 0.001),
      );
      expect(
        ContentCardMetrics.sizeOf(ContentCardKind.channelTile),
        const Size(120, 120),
      );
    });
  });

  group('ContentCard widget', () {
    Future<void> pumpCard(
      WidgetTester tester,
      ContentCard card,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.tvDark(),
          home: Scaffold(
            backgroundColor: AppColors.ink,
            body: Center(child: card),
          ),
        ),
      );
    }

    testWidgets('renders all four kinds with titles', (tester) async {
      for (final kind in ContentCardKind.values) {
        await pumpCard(
          tester,
          ContentCard(
            kind: kind,
            title: kind.name,
            progress: kind == ContentCardKind.continueWatching ? 0.4 : null,
          ),
        );
        expect(find.text(kind.name), findsOneWidget);
        expect(find.byType(FocusableSurface), findsOneWidget);
      }
    });

    testWidgets('Continue Watching paints Signal progress track', (
      tester,
    ) async {
      await pumpCard(
        tester,
        const ContentCard(
          kind: ContentCardKind.continueWatching,
          title: 'Episode 3',
          progress: 0.55,
        ),
      );

      expect(
        find.byKey(const ValueKey<String>('content-card-signal-progress')),
        findsOneWidget,
      );
      final bar = tester.widgetList<ColoredBox>(find.byType(ColoredBox));
      expect(
        bar.any((box) => box.color == AppColors.signal),
        isTrue,
        reason: 'progress fill must use Signal',
      );
    });
  });

  testWidgets('MiIptvApp still boots with ContentCard on home', (tester) async {
    await tester.pumpWidget(const MiIptvApp());
    expect(find.byType(ContentCard), findsOneWidget);
  });
}
