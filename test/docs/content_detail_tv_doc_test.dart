import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('DSN-034 doc locks detail layout and PRD-013 deferral', () {
    final doc = File('docs/design/content_detail_tv.md').readAsStringSync();
    expect(doc, contains('DSN-034'));
    expect(doc, contains('Large art'));
    expect(doc, contains('Play'));
    expect(doc, contains('Resume'));
    expect(doc, contains('Favorite'));
    expect(doc, contains('Related'));
    expect(doc, contains('PRD-013'));
    expect(doc, contains('TvContentDetailPage'));
    expect(doc, contains('deferred'));
  });
}
