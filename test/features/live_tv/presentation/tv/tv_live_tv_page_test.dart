import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/core/widgets/status_badge.dart';
import 'package:mi_iptv/core/widgets/stream_failure_recovery_overlay.dart';
import 'package:mi_iptv/features/live_tv/presentation/tv/tv_live_tv_page.dart';

void main() {
  Future<void> pump(WidgetTester tester, {TvLiveTvPage? page}) async {
    await tester.binding.setSurfaceSize(const Size(1920, 1080));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.tvDark(),
        home: page ?? const TvLiveTvPage(),
      ),
    );
    await tester.pump();
  }

  testWidgets('DSN-033 shows video stage, LIVE badge, source, and channel info', (
    tester,
  ) async {
    await pump(tester);

    expect(find.byIcon(Icons.play_circle_outline), findsOneWidget);
    expect(find.text('LIVE'), findsOneWidget);
    expect(find.text('Home Xtream'), findsWidgets);
    expect(find.text('Signal News'), findsOneWidget);
    expect(find.text('12'), findsOneWidget);
    expect(find.textContaining('12  Signal News'), findsOneWidget);
    expect(find.byType(StatusBadge), findsNWidgets(2));
  });

  testWidgets('channel list selection updates info overlay', (tester) async {
    await pump(tester);

    await tester.tap(find.textContaining('24  Ember Sports'));
    await tester.pump();

    expect(find.text('Ember Sports'), findsWidgets);
    expect(find.text('24'), findsOneWidget);
  });

  testWidgets('arrow keys zap channels', (tester) async {
    await pump(tester);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();

    expect(find.text('Ember Sports'), findsWidgets);
  });

  testWidgets('DSN-039 keeps channel context and offers recovery actions', (
    tester,
  ) async {
    var retried = false;
    var switched = false;
    var backed = false;

    await pump(
      tester,
      page: TvLiveTvPage(
        streamFailed: true,
        onRetry: () => retried = true,
        onSwitchSource: () => switched = true,
        onBackToChannels: () => backed = true,
      ),
    );

    expect(find.byIcon(Icons.play_circle_outline), findsOneWidget);
    expect(find.text('Signal News'), findsWidgets);
    expect(find.text('12'), findsWidgets);
    expect(find.text('Home Xtream'), findsWidgets);
    expect(
      find.text(StreamFailureRecoveryOverlay.defaultMessage),
      findsOneWidget,
    );
    expect(find.textContaining('12  Signal News'), findsNothing);
    expect(find.text('Retry'), findsOneWidget);
    expect(find.text('Switch source'), findsOneWidget);
    expect(find.text('Back to channels'), findsOneWidget);

    await tester.tap(find.text('Retry'));
    await tester.tap(find.text('Switch source'));
    await tester.tap(find.text('Back to channels'));
    await tester.pump();

    expect(retried, isTrue);
    expect(switched, isTrue);
    expect(backed, isTrue);
    expect(find.text('Signal News'), findsWidgets);
  });
}
