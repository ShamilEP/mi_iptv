import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Locks PRD-030 MVP user-story handoff for previously uncovered FRs.
void main() {
  test('PRD-030 user stories cover uncovered MVP FRs with Gherkin', () {
    final file = File('docs/product/user_stories_mvp.md');
    expect(file.existsSync(), isTrue);

    final text = file.readAsStringSync();
    expect(text, contains('PRD-030'));
    expect(text, contains('US-01'));
    expect(text, contains('US-09'));
    expect(text, contains('US-24'));

    const frs = <String>[
      'FR-002',
      'FR-004',
      'FR-005',
      'FR-012',
      'FR-013',
      'FR-014',
      'FR-015',
      'FR-016',
      'FR-026',
      'FR-027',
      'FR-028',
      'FR-029',
      'FR-032',
      'FR-034',
      'FR-037',
      'FR-038',
    ];
    for (final fr in frs) {
      expect(text, contains(fr), reason: '$fr missing from user stories');
    }

    expect(text, contains('Given'));
    expect(text, contains('When'));
    expect(text, contains('Then'));
    expect(text, contains('10s'));
    expect(text, contains('15%'));
    expect(text, contains('send-to-TV'));
    expect(text, contains('Widevine L3'));
  });
}
