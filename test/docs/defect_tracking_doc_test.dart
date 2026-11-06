import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Locks QA-005 deliverable presence and required sections.
void main() {
  test('QA-005 defect tracking doc covers workflow and severities', () {
    final file = File('docs/qa/defect_tracking.md');
    expect(
      file.existsSync(),
      isTrue,
      reason: 'docs/qa/defect_tracking.md missing',
    );

    final text = file.readAsStringSync();
    expect(text, contains('QA-005'));
    expect(text, contains('Workflow'));
    expect(text, contains('New'));
    expect(text, contains('Triaged'));
    expect(text, contains('Blocker'));
    expect(text, contains('Critical'));
    expect(text, contains('Major'));
    expect(text, contains('Minor'));
    expect(text, contains('Trivial'));
    expect(text, contains('Severity'));
    expect(text, contains('GitHub Issues'));
  });

  test('QA-005 release checklist covers go/no-go Must gates', () {
    final file = File('docs/qa/release_checklist.md');
    expect(
      file.existsSync(),
      isTrue,
      reason: 'docs/qa/release_checklist.md missing',
    );

    final text = file.readAsStringSync();
    expect(text, contains('QA-005'));
    expect(text, contains('GO'));
    expect(text, contains('NO-GO'));
    expect(text, contains('flutter analyze'));
    expect(text, contains('flutter test'));
    expect(text, contains('Blocker'));
    expect(text, contains('Critical'));
    expect(text, contains('Sprint 0'));
    expect(text, contains('MVP'));
    expect(text, contains('Release 1'));
  });
}
