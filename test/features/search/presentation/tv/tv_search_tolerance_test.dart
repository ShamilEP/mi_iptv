import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/features/search/presentation/tv/tv_search_page.dart';
import 'package:mi_iptv/features/search/presentation/tv/tv_search_tolerance.dart';

void main() {
  final catalog = TvSearchPage.demoCatalog;

  test('DSN-065 contains match keeps Signal News for sig', () {
    final outcome = TolerantSearch.query('sig', catalog);
    expect(outcome.matches.map((e) => e.id), contains('ch-12'));
    expect(outcome.didYouMean, isNull);
  });

  test('DSN-065 typo recovers Harbor Lights as suggestion or match', () {
    final outcome = TolerantSearch.query('harbr', catalog);
    expect(
      outcome.matches.any((e) => e.id == 'vod-1') ||
          outcome.suggestions.contains('Harbor Lights') ||
          outcome.didYouMean == 'Harbor Lights',
      isTrue,
    );
  });

  test('DSN-065 far typo with no catalog hit yields empty matches', () {
    final outcome = TolerantSearch.query('zzzz', catalog);
    expect(outcome.matches, isEmpty);
    expect(outcome.didYouMean, isNull);
  });
}
