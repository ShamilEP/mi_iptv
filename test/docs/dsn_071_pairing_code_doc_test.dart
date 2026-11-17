import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('DSN-071 doc locks TV display and Companion entry shells', () {
    final file = File('docs/design/pairing_code.md');
    expect(file.existsSync(), isTrue);
    final text = file.readAsStringSync();
    expect(text, contains('DSN-071'));
    expect(text, contains('PRD-008'));
    expect(text, contains('Release 2'));
    expect(text, contains('TvPairingCodePage'));
    expect(text, contains('CompanionPairingCodePage'));
    expect(text, contains('6-digit'));
    expect(text, contains('482913'));
  });
}
