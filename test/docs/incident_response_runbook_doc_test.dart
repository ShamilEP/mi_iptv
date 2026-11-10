import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Locks SEC-052 incident response runbook presence and required DoD sections.
void main() {
  test('SEC-052 runbook covers roles, compromise, notification, contact', () {
    final file = File('docs/security/incident_response_runbook.md');
    expect(
      file.existsSync(),
      isTrue,
      reason: 'docs/security/incident_response_runbook.md missing',
    );

    final text = file.readAsStringSync();
    expect(text, contains('SEC-052'));
    expect(text, contains('Roles'));
    expect(text, contains('Incident lead'));
    expect(text, contains('Security contact'));
    expect(text, contains('Token / key compromise'));
    expect(text, contains('secure storage'));
    expect(text, contains('refresh'));
    expect(text, contains('User notification'));
    expect(text, contains('security@'));
    expect(text, contains('security-client.mdc'));
    expect(text, contains('SEC-002'));
    expect(text, isNot(contains('eyJ')));
  });
}
