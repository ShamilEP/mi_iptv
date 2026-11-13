import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('settings_tv doc locks TV-080 categories and TV-081/082 deferrals', () {
    final doc = File('docs/design/settings_tv.md').readAsStringSync();
    expect(doc, contains('TV-080'));
    expect(doc, contains('Account'));
    expect(doc, contains('Sources'));
    expect(doc, contains('Network'));
    expect(doc, contains('Language'));
    expect(doc, contains('Playback'));
    expect(doc, contains('TV-081'));
    expect(doc, contains('TV-082'));
    expect(doc, contains('Diagnostics'));
  });
}
