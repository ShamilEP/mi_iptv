import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Locks CMP-001 / PRD-011 ADR deliverable.
void main() {
  test('ADR-001 documents Flutter companion and one shared Dart package', () {
    final file = File('docs/architecture/adr-001-companion-stack-shared-domain.md');
    expect(file.existsSync(), isTrue);

    final text = file.readAsStringSync();
    final lower = text.toLowerCase();
    expect(text, contains('ADR-001'));
    expect(text, contains('CMP-001'));
    expect(text, contains('PRD-011'));
    expect(text, contains('Flutter'));
    expect(lower, contains('one dart package'));
    expect(text, contains('main_companion.dart'));
    expect(text, contains('ClientKind'));
    expect(text, contains('presentation/companion'));
    expect(text, contains('Accepted'));
  });
}
