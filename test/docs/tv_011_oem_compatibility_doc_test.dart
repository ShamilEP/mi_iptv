import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('TV-011 doc locks key map, decoder, display, quirks, and native reader', () {
    final file = File('docs/architecture/tv-011-oem-compatibility.md');
    expect(file.existsSync(), isTrue);
    final text = file.readAsStringSync();
    expect(text, contains('TV-011'));
    expect(text, contains('NFR-009'));
    expect(text, contains('TvRemoteKeyMapper'));
    expect(text, contains('CH+'));
    expect(text, contains('OemDecoderCapabilities'));
    expect(text, contains('OemDisplayMode'));
    expect(text, contains('OemQuirk'));
    expect(text, contains('OemCompatibilityPlugin'));
    expect(text, contains('AppDependencies'));
    expect(text, contains('AppNavigator'));
  });

  test('native OEM plugin and MainActivity registration exist', () {
    expect(
      File(
        'android/app/src/main/kotlin/com/example/mi_iptv/oem/OemCompatibilityPlugin.kt',
      ).existsSync(),
      isTrue,
    );
    final main = File(
      'android/app/src/main/kotlin/com/example/mi_iptv/MainActivity.kt',
    ).readAsStringSync();
    expect(main, contains('OemCompatibilityPlugin'));
  });
}
