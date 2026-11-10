import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/core/widgets/mi_toggle.dart';
import 'package:mi_iptv/features/history/presentation/tv/tv_history_models.dart';
import 'package:mi_iptv/features/history/presentation/tv/tv_history_page.dart';
import 'package:mi_iptv/features/home/presentation/tv/tv_home_page.dart';

void main() {
  Future<void> pump(WidgetTester tester, {TvHistoryPage? page}) async {
    await tester.binding.setSurfaceSize(const Size(1920, 1080));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.tvDark(),
        home: page ?? const TvHistoryPage(),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('DSN-063 shows History separate from Continue watching', (
    tester,
  ) async {
    await pump(tester);

    expect(find.text(TvHistoryCopy.title), findsOneWidget);
    expect(find.text(TvHistoryCopy.body), findsOneWidget);
    expect(find.textContaining('Continue watching'), findsOneWidget);
    expect(find.text(TvHomePage.continueWatchingTitle), findsNothing);
    expect(find.text('Harbor Lights'), findsOneWidget);
    expect(find.text(TvHistoryCopy.privacySection), findsOneWidget);
    expect(find.byType(MiToggle), findsOneWidget);
  });

  testWidgets('privacy toggle pauses saving and clear empties the list', (
    tester,
  ) async {
    var save = true;
    var cleared = 0;
    await pump(
      tester,
      page: TvHistoryPage(
        onSaveHistoryChanged: (value) => save = value,
        onClearHistory: () => cleared++,
      ),
    );

    await tester.tap(find.byKey(const ValueKey<String>('history-save-toggle')));
    await tester.pumpAndSettle();
    expect(save, isFalse);
    expect(find.text(TvHistoryCopy.pausedBanner), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey<String>('history-clear')));
    await tester.pumpAndSettle();

    expect(cleared, 1);
    expect(find.text(TvHistoryCopy.emptyTitle), findsOneWidget);
    expect(find.text(TvHistoryCopy.clearDoneLabel), findsOneWidget);
    expect(find.text('Harbor Lights'), findsNothing);
  });

  testWidgets('remove drops a single history row', (tester) async {
    TvHistoryItem? removed;
    await pump(
      tester,
      page: TvHistoryPage(onRemove: (item) => removed = item),
    );

    await tester.tap(find.text(TvHistoryCopy.removeLabel).first);
    await tester.pumpAndSettle();

    expect(removed?.id, 'h-1');
    expect(find.text('Harbor Lights'), findsNothing);
    expect(find.text('Signal News'), findsOneWidget);
  });
}
