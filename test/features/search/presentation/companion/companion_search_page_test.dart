import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/features/search/presentation/companion/companion_search_copy.dart';
import 'package:mi_iptv/features/search/presentation/companion/companion_search_page.dart';
import 'package:mi_iptv/features/search/presentation/shared/search_hit.dart';

void main() {
  Future<void> pump(
    WidgetTester tester, {
    CompanionSearchPage? page,
  }) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.companionLight(),
        home: page ?? const CompanionSearchPage(),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('CMP-041 shows field and Channels / VOD groups', (tester) async {
    await pump(tester);

    expect(find.text(CompanionSearchCopy.title), findsWidgets);
    expect(
      find.byKey(const ValueKey<String>('companion-search-field')),
      findsOneWidget,
    );
    expect(find.text(CompanionSearchCopy.channelsGroup), findsOneWidget);
    expect(find.text(CompanionSearchCopy.vodGroup), findsOneWidget);
    expect(find.text('Signal News'), findsOneWidget);
    expect(find.text('Harbor Lights'), findsOneWidget);
  });

  testWidgets('typing filters to channel matches', (tester) async {
    await pump(tester);

    await tester.enterText(
      find.byKey(const ValueKey<String>('companion-search-field')),
      'sig',
    );
    await tester.pumpAndSettle();

    expect(find.text('Signal News'), findsOneWidget);
    expect(find.text(CompanionSearchCopy.channelsGroup), findsOneWidget);
    expect(find.text('Harbor Lights'), findsNothing);
    expect(find.text(CompanionSearchCopy.vodGroup), findsNothing);
  });

  testWidgets('empty query shows Clear empty action path', (tester) async {
    await pump(
      tester,
      page: const CompanionSearchPage(initialQuery: 'zzzz'),
    );

    expect(find.text(CompanionSearchCopy.emptyTitle), findsOneWidget);
    await tester.tap(find.text(CompanionSearchCopy.emptyAction).first);
    await tester.pumpAndSettle();
    expect(find.text(CompanionSearchCopy.channelsGroup), findsOneWidget);
  });

  testWidgets('selecting a result invokes callback', (tester) async {
    SearchHit? selected;
    await pump(
      tester,
      page: CompanionSearchPage(onResultSelected: (item) => selected = item),
    );

    await tester.tap(
      find.byKey(const ValueKey<String>('companion-search-vod-1')),
    );
    await tester.pumpAndSettle();
    expect(selected?.id, 'vod-1');
  });
}
