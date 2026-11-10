import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/features/live_tv/presentation/tv/tv_epg_event_detail.dart';
import 'package:mi_iptv/features/live_tv/presentation/tv/tv_epg_grid_page.dart';
import 'package:mi_iptv/features/live_tv/presentation/tv/tv_epg_models.dart';

void main() {
  Future<void> pump(WidgetTester tester, {TvEpgGridPage? page}) async {
    await tester.binding.setSurfaceSize(const Size(1920, 1080));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.tvDark(),
        home: page ?? const TvEpgGridPage(),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('DSN-060 shows channel × time grid and Now highlight', (
    tester,
  ) async {
    await pump(tester);

    expect(find.text(TvEpgCopy.title), findsOneWidget);
    expect(find.text('12  Signal News'), findsWidgets);
    expect(find.text('24  Ember Sports'), findsOneWidget);
    expect(find.text('48  Cloud Cinema'), findsOneWidget);
    expect(find.text('20:00'), findsOneWidget);
    expect(find.text('Evening bulletin'), findsWidgets);
    expect(find.text(TvEpgCopy.nowLabel), findsWidgets);
    expect(find.byType(TvEpgEventDetail), findsOneWidget);
    expect(find.byKey(const ValueKey<String>('epg-event-12-a')), findsOneWidget);
  });

  testWidgets('initial focus lands on a current event and fills detail', (
    tester,
  ) async {
    await pump(tester);

    expect(find.text('Evening bulletin'), findsWidgets);
    expect(
      find.descendant(
        of: find.byType(TvEpgEventDetail),
        matching: find.text('Evening bulletin'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byType(TvEpgEventDetail),
        matching: find.text(TvEpgCopy.nowLabel),
      ),
      findsOneWidget,
    );
  });

  testWidgets('block navigation updates event detail', (tester) async {
    await pump(tester);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: find.byType(TvEpgEventDetail),
        matching: find.text('World desk'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('selecting a block reports the event', (tester) async {
    TvEpgEvent? selected;
    await pump(
      tester,
      page: TvEpgGridPage(onEventSelected: (event) => selected = event),
    );

    await tester.tap(find.text('Live kickoff'));
    await tester.pumpAndSettle();

    expect(selected?.id, '24-b');
    expect(
      find.descendant(
        of: find.byType(TvEpgEventDetail),
        matching: find.text('Live kickoff'),
      ),
      findsOneWidget,
    );
  });
}
