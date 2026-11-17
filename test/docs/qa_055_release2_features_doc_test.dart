import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('QA-055 doc maps Release 2 topics to provisional stories and suite', () {
    final file = File('docs/qa/release2_features.md');
    expect(file.existsSync(), isTrue);
    final text = file.readAsStringSync();
    expect(text, contains('QA-055'));
    expect(text, contains('PRD-033'));
    expect(text, contains('prd_033_release2_provisional_ac.md'));
    expect(text, contains('release2_features_test.dart'));
    expect(text, contains('US-R2-01'));
    expect(text, contains('US-R2-02'));
    expect(text, contains('Personalization'));
    expect(text, contains('Pairing-code'));
    expect(text, contains('Deferred'));
  });

  test('PRD-033 provisional AC covers US-R2-01 and US-R2-02', () {
    final file = File('docs/product/prd_033_release2_provisional_ac.md');
    expect(file.existsSync(), isTrue);
    final text = file.readAsStringSync();
    expect(text, contains('provisional'));
    expect(text, contains('PRD-033'));
    expect(text, contains('US-R2-01'));
    expect(text, contains('US-R2-02'));
    expect(text, contains('personalization'));
    expect(text, contains('pairing'));
  });
}
