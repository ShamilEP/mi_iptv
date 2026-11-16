import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('QA-041 doc maps FR-027 upgrade safety to executable suite', () {
    final file = File('docs/qa/upgrades_and_migrations.md');
    expect(file.existsSync(), isTrue);
    final text = file.readAsStringSync();
    expect(text, contains('QA-041'));
    expect(text, contains('FR-027'));
    expect(text, contains('US-18'));
    expect(text, contains('TV-015'));
    expect(text, contains('upgrades_and_migrations_test.dart'));
    expect(text, contains('syncVersion'));
    expect(text, contains('LocalMediaSchemaException'));
    expect(text, contains('AppDatabase'));
  });
}
