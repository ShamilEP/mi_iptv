import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('QA-019 doc locks FR matrix, PRD-030, and deferred TV-081/082', () {
    final doc = File('docs/qa/qa-019_fr_acceptance.md').readAsStringSync();
    expect(doc, contains('QA-019'));
    expect(doc, contains('PRD-030'));
    for (final fr in <String>[
      'FR-012',
      'FR-013',
      'FR-014',
      'FR-015',
      'FR-016',
      'FR-024',
      'FR-026',
      'FR-028',
    ]) {
      expect(doc, contains(fr));
    }
    expect(doc, contains('TV-081'));
    expect(doc, contains('TV-082'));
    expect(doc, contains('fr_acceptance_mvp_test.dart'));
    expect(doc, contains('Settings'));
    expect(doc, contains('diagnostics'));
    expect(doc, contains('source'));
    expect(doc, contains('Resume'));
  });
}
