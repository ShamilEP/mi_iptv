import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/features/search/presentation/tv/tv_search_copy.dart';
import 'package:mi_iptv/features/search/presentation/tv/tv_search_page.dart';
import 'package:mi_iptv/features/search/presentation/tv/tv_search_result.dart';
import 'package:mi_iptv/features/search/presentation/tv/tv_search_suggestions.dart';

void main() {
  Future<void> pump(WidgetTester tester, {required String query}) async {
    await tester.binding.setSurfaceSize(const Size(1920, 1080));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.tvDark(),
        home: TvSearchPage(initialQuery: query),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('DSN-065 shows suggestion chips for partial query', (
    tester,
  ) async {
    await pump(tester, query: 'har');

    expect(find.text(TvSearchCopy.suggestionsLabel), findsOneWidget);
    expect(
      find.byKey(const ValueKey<String>('search-suggestion-Harbor Lights')),
      findsOneWidget,
    );

    await tester.tap(
      find.byKey(const ValueKey<String>('search-suggestion-Harbor Lights')),
    );
    await tester.pumpAndSettle();

    expect(
      tester
          .widget<Text>(find.byKey(const ValueKey<String>('search-large-query')))
          .data,
      'Harbor Lights',
    );
    expect(find.text('Harbor Lights'), findsWidgets);
  });

  testWidgets('DSN-065 shows Did you mean for a hard typo', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1920, 1080));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.tvDark(),
        home: const TvSearchPage(
          // Edit distance 3 vs "Zebra" → suggestion only (not a fuzzy hit).
          initialQuery: 'zeeeebra',
          catalog: <TvSearchResult>[
            TvSearchResult(
              id: 'vod-z',
              title: 'Zebra',
              subtitle: 'Movie',
              kind: TvSearchResultKind.vod,
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(TvSearchDidYouMean), findsOneWidget);
    expect(find.textContaining(TvSearchCopy.didYouMeanPrefix), findsOneWidget);
    expect(find.text(TvSearchCopy.emptyTitle), findsOneWidget);

    await tester.tap(
      find.byKey(const ValueKey<String>('search-did-you-mean-apply')),
    );
    await tester.pumpAndSettle();

    expect(
      tester
          .widget<Text>(find.byKey(const ValueKey<String>('search-large-query')))
          .data,
      'Zebra',
    );
    expect(find.text(TvSearchCopy.vodGroup), findsOneWidget);
  });
}
