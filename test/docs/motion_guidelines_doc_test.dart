import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Locks DSN-020 motion guidelines deliverable.
void main() {
  test('DSN-020 motion guidelines cover reduced motion and tokens', () {
    final file = File('docs/design/motion_guidelines.md');
    expect(
      file.existsSync(),
      isTrue,
      reason: 'docs/design/motion_guidelines.md missing',
    );

    final text = file.readAsStringSync();
    expect(text, contains('DSN-020'));
    expect(text, contains('AppMotion'));
    expect(text, contains('reduced motion'));
    expect(text, contains('durationOf'));
    expect(text, contains('fast'));
    expect(text.toLowerCase(), contains('functional'));
    expect(text, contains('disableAnimations'));
  });
}
