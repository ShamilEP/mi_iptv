import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('TV-015 doc covers versioned Drift migrations and update safety', () {
    final file = File('docs/architecture/tv-015-local-db-migrations.md');
    expect(file.existsSync(), isTrue);
    final text = file.readAsStringSync();
    expect(text, contains('TV-015'));
    expect(text, contains('FR-027'));
    expect(text, contains('AppDatabaseMigrations'));
    expect(text, contains('LocalSchemaMetaRows'));
    expect(text, contains('LocalMediaSchemaException'));
    expect(text.toLowerCase(), contains('outbox'));
    expect(text.toLowerCase(), contains('favorites'));
  });
}
