import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('QA-039 doc locks airplane/backend-down non-blocking coverage', () {
    final doc = File('docs/qa/offline_first.md').readAsStringSync();
    expect(doc, contains('QA-039'));
    expect(doc, contains('NFR-004'));
    expect(doc, contains('SRS §19'));
    expect(doc, contains('Airplane'));
    expect(doc, contains('Backend down'));
    expect(doc, contains('Interaction'));
    expect(doc, contains('Playback'));
    expect(doc, contains('offline_first_test.dart'));
    expect(doc, contains('TV-010'));
  });
}
