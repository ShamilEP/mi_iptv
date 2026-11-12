import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('QA-025 doc locks first focus, determinism, Back, and traps', () {
    final doc = File('docs/qa/tv_dpad_navigation.md').readAsStringSync();
    expect(doc, contains('QA-025'));
    expect(doc, contains('First focus'));
    expect(doc, contains('Determinism'));
    expect(doc, contains('Focus trap'));
    expect(doc, contains('Back'));
    expect(doc, contains('tv_dpad_navigation_test.dart'));
    expect(doc, contains('SRS §12'));
  });
}
