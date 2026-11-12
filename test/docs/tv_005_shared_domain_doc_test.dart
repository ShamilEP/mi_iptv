import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('TV-005 doc locks shared domain + sync integration', () {
    final file = File('docs/architecture/tv-005-shared-domain-integration.md');
    expect(file.existsSync(), isTrue);
    final text = file.readAsStringSync();
    expect(text, contains('TV-005'));
    expect(text, contains('PRD-011'));
    expect(text, contains('ADR-001'));
    expect(text, contains('AppDependencies'));
    expect(text, contains('ResolveSyncConflict'));
    expect(text, contains('ContentItem'));
    expect(text, contains('FavoriteEntry'));
    expect(text, contains('PlaybackProgress'));
  });
}
