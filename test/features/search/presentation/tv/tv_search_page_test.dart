import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/core/widgets/content_card.dart';
import 'package:mi_iptv/core/widgets/focusable_surface.dart';
import 'package:mi_iptv/core/widgets/tv_on_screen_keyboard.dart';
import 'package:mi_iptv/features/search/presentation/tv/tv_search_copy.dart';
import 'package:mi_iptv/features/search/presentation/tv/tv_search_page.dart';
import 'package:mi_iptv/features/search/presentation/tv/tv_search_result.dart';

void main() {
  Future<void> pump(WidgetTester tester, {TvSearchPage? page}) async {
    await tester.binding.setSurfaceSize(const Size(1920, 1080));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.tvDark(), home: page ?? const TvSearchPage()),
    );
    await tester.pump();
  }

  testWidgets('DSN-035 shows large field, OSK, and grouped results', (
    tester,
  ) async {
    await pump(tester);

    expect(find.text(TvSearchCopy.title), findsWidgets);
    expect(find.text(TvSearchCopy.fieldHint), findsWidgets);
    expect(find.byType(TvOnScreenKeyboard), findsOneWidget);
    expect(find.text(TvSearchCopy.channelsGroup), findsOneWidget);
    expect(find.text(TvSearchCopy.vodGroup), findsOneWidget);
    expect(find.text('Signal News'), findsOneWidget);
    expect(find.text('Harbor Lights'), findsOneWidget);
    expect(find.byType(ContentCard), findsWidgets);
    expect(find.byType(FocusableSurface), findsWidgets);
    expect(find.byKey(const ValueKey('search-large-query')), findsOneWidget);
    expect(
      tester.widget<Text>(find.byKey(const ValueKey('search-large-query'))).data,
      TvSearchCopy.fieldHint,
    );
  });

  testWidgets('typing filters channels and VOD groups', (tester) async {
    await pump(tester);

    await tester.tap(find.text('s'));
    await tester.pump();
    await tester.tap(find.text('i'));
    await tester.pump();
    await tester.tap(find.text('g'));
    await tester.pump();

    expect(
      tester.widget<Text>(find.byKey(const ValueKey('search-large-query'))).data,
      'sig',
    );
    expect(find.text('Signal News'), findsOneWidget);
    expect(find.text(TvSearchCopy.channelsGroup), findsOneWidget);
    expect(find.text('Harbor Lights'), findsNothing);
  });

  testWidgets('empty matches show clear action', (tester) async {
    await pump(tester, page: const TvSearchPage(initialQuery: 'zzzz'));

    expect(find.text(TvSearchCopy.emptyTitle), findsOneWidget);
    expect(find.text(TvSearchCopy.channelsGroup), findsNothing);
    await tester.tap(find.text(TvSearchCopy.emptyAction));
    await tester.pump();
    expect(find.text(TvSearchCopy.channelsGroup), findsOneWidget);
  });

  testWidgets('selecting a result invokes callback', (tester) async {
    TvSearchResult? selected;
    await pump(
      tester,
      page: TvSearchPage(onResultSelected: (item) => selected = item),
    );

    await tester.tap(find.byKey(const ValueKey('search-vod-1')));
    await tester.pump();
    expect(selected?.id, 'vod-1');
  });
}
