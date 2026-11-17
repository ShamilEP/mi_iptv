import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('QA-040 doc maps NFR-012 overflow and formats to executable suite', () {
    final file = File('docs/qa/localization.md');
    expect(file.existsSync(), isTrue);
    final text = file.readAsStringSync();
    expect(text, contains('QA-040'));
    expect(text, contains('NFR-012'));
    expect(text, contains('TV-014'));
    expect(text, contains('localization_test.dart'));
    expect(text, contains('String overflow'));
    expect(text, contains('Locale formats'));
    expect(text, contains('EN'));
    expect(text, contains('ES'));
    expect(text, contains('zh-CN'));
    expect(text, contains('FR'));
  });
}
