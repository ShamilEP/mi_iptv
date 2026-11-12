import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('CMP-003 doc maps light theme tokens and companion type scale', () {
    final file = File('docs/architecture/cmp-003-companion-light-theme.md');
    expect(file.existsSync(), isTrue);
    final text = file.readAsStringSync();
    expect(text, contains('CMP-003'));
    expect(text, contains('DSN-001'));
    expect(text, contains('DSN-003'));
    expect(text, contains('CMP-002'));
    expect(text, contains('companionLight'));
    expect(text, contains('0A6F68'));
    expect(text, contains('B8431B'));
    expect(text, contains('28'));
    expect(text, contains('20'));
    expect(text, contains('16'));
    expect(text, contains('13'));
    expect(text, contains('optional'));
  });
}
