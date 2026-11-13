import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('CMP-006 doc locks catalog, favorites, TV status, and clear offline', () {
    final file = File('docs/architecture/cmp-006-companion-offline-cache.md');
    expect(file.existsSync(), isTrue);
    final text = file.readAsStringSync();
    expect(text, contains('CMP-006'));
    expect(text, contains('NFR-011'));
    expect(text, contains('CompanionLocalCache'));
    expect(text, contains('LinkedTvSnapshot'));
    expect(text, contains('offlineCached'));
    expect(text, contains('favorites'));
    expect(text, contains('catalog'));
    expect(text, contains('retry'));
  });
}
