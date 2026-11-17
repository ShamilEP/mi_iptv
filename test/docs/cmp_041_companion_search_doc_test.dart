import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('CMP-041 Companion Search design doc exists', () {
    final file = File('docs/design/search_companion.md');
    expect(file.existsSync(), isTrue);
    final text = file.readAsStringSync();
    expect(text, contains('CMP-041'));
    expect(text, contains('CompanionSearchPage'));
    expect(text, contains('Channels'));
    expect(text, contains('VOD'));
    expect(text, contains('BE-052'));
    expect(text, contains('TolerantSearch'));
  });
}
