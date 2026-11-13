import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('CMP-008 doc locks EN/ES/zh-CN/FR, catalogs, and formats', () {
    final file = File('docs/architecture/cmp-008-companion-localization.md');
    expect(file.existsSync(), isTrue);
    final text = file.readAsStringSync();
    expect(text, contains('CMP-008'));
    expect(text, contains('NFR-012'));
    expect(text, contains('PRD-012'));
    expect(text, contains('EN'));
    expect(text, contains('ES'));
    expect(text, contains('zh-CN'));
    expect(text, contains('FR'));
    expect(text, contains('AppStringCatalog'));
    expect(text, contains('LocaleFormats'));
    expect(text, contains('CompanionLanguagePage'));
  });
}
