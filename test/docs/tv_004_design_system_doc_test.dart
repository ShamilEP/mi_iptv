import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('TV-004 doc maps theme, type, focus, and 12 states', () {
    final file = File('docs/architecture/tv-004-design-system-tv.md');
    expect(file.existsSync(), isTrue);
    final text = file.readAsStringSync();
    expect(text, contains('TV-004'));
    expect(text, contains('DSN-001'));
    expect(text, contains('DSN-003'));
    expect(text, contains('DSN-006'));
    expect(text, contains('DSN-010'));
    expect(text, contains('AppTheme.tvDark'));
    expect(text, contains('tvLabelSize'));
    expect(text, contains('16'));
    expect(text, contains('FocusStyles'));
    expect(text, contains('1.05'));
    expect(text, contains('UiStateCatalog'));
    expect(text, contains('FocusableSurface'));
  });
}
