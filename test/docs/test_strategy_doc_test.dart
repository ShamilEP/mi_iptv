import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Locks QA-001 deliverable presence and required sections.
void main() {
  test('QA-001 test strategy doc covers phases, gates, and severity', () {
    final file = File('docs/qa/test_strategy.md');
    expect(file.existsSync(), isTrue, reason: 'docs/qa/test_strategy.md missing');

    final text = file.readAsStringSync();
    expect(text, contains('QA-001'));
    expect(text, contains('Sprint 0'));
    expect(text, contains('MVP'));
    expect(text, contains('Release 1'));
    expect(text, contains('Entry'));
    expect(text, contains('Exit'));
    expect(text, contains('Blocker'));
    expect(text, contains('Critical'));
    expect(text, contains('Major'));
    expect(text, contains('Minor'));
    expect(text, contains('Trivial'));
    expect(text, contains('Defect process'));
    expect(text, contains('Severity definitions'));
  });
}
