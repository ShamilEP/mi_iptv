import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('QA-052 doc maps Play TV quality and App Store readiness', () {
    final file = File('docs/qa/store_compliance.md');
    expect(file.existsSync(), isTrue);
    final text = file.readAsStringSync();
    expect(text, contains('QA-052'));
    expect(text, contains('SRS §1.3'));
    expect(text, contains('PRD-042'));
    expect(text, contains('Play TV'));
    expect(text, contains('Leanback'));
    expect(text, contains('320'));
    expect(text, contains('CMP-010'));
    expect(text, contains('App Store'));
    expect(text, contains('StoreCompliance'));
    expect(text, contains('store_compliance_test.dart'));
  });
}
