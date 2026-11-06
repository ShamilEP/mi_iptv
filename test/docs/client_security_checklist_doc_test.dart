import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Locks SEC-002 deliverable presence and required sections.
void main() {
  test('SEC-002 checklist covers controls, task map, and sprint review', () {
    final file = File('docs/security/client_security_checklist.md');
    expect(
      file.existsSync(),
      isTrue,
      reason: 'docs/security/client_security_checklist.md missing',
    );

    final text = file.readAsStringSync();
    expect(text, contains('SEC-002'));
    expect(text, contains('SEC-C01'));
    expect(text, contains('SEC-C13'));
    expect(text, contains('Acceptance criterion'));
    expect(text, contains('Sprint review'));
    expect(text, contains('auth'));
    expect(text, contains('sources'));
    expect(text, contains('HTTPS'));
    expect(text, contains('secure storage'));
    expect(text, contains('JWT'));
    expect(text, contains('security-client.mdc'));
  });
}
