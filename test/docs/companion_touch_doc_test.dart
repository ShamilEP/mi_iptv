import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('QA-026 doc locks pairing, remote, and send-to-TV on Android/iOS', () {
    final doc = File('docs/qa/companion_touch.md').readAsStringSync();
    expect(doc, contains('QA-026'));
    expect(doc, contains('Pairing'));
    expect(doc, contains('Remote'));
    expect(doc, contains('Send-to-TV'));
    expect(doc, contains('Android'));
    expect(doc, contains('iOS'));
    expect(doc, contains('companion_touch_test.dart'));
    expect(doc, contains('SRS §22'));
  });
}
