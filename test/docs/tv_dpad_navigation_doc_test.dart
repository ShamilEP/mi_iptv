import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('QA-025 / TV-121 doc locks first focus, determinism, Back, traps, memory',
      () {
    final doc = File('docs/qa/tv_dpad_navigation.md').readAsStringSync();
    expect(doc, contains('QA-025'));
    expect(doc, contains('TV-121'));
    expect(doc, contains('First focus'));
    expect(doc, contains('Determinism'));
    expect(doc, contains('Focus trap'));
    expect(doc, contains('Back'));
    expect(doc, contains('Back stack'));
    expect(doc, contains('Last-focus memory'));
    expect(doc, contains('tv_dpad_navigation_test.dart'));
    expect(doc, contains('SRS §12'));
  });

  test('TV-121 architecture doc locks DoD rules and suite path', () {
    final doc =
        File('docs/architecture/tv-121-dpad-navigation-tests.md').readAsStringSync();
    expect(doc, contains('TV-121'));
    expect(doc, contains('QA-025'));
    expect(doc, contains('First focus'));
    expect(doc, contains('Determinism'));
    expect(doc, contains('Back stack'));
    expect(doc, contains('focus traps'));
    expect(doc, contains('Last-focus memory'));
    expect(doc, contains('tv_dpad_navigation_test.dart'));
  });
}
