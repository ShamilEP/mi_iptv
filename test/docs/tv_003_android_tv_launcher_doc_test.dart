import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Locks TV-003 Android TV Leanback launcher packaging.
void main() {
  test('TV-003 doc covers Leanback, banner, and non-touch requirements', () {
    final file = File('docs/architecture/tv-003-android-tv-launcher.md');
    expect(file.existsSync(), isTrue);

    final text = file.readAsStringSync();
    final lower = text.toLowerCase();
    expect(text, contains('TV-003'));
    expect(text, contains('DSN-005'));
    expect(text, contains('LEANBACK_LAUNCHER'));
    expect(text, contains('320×180'));
    expect(lower, contains('touchscreen'));
    expect(lower, contains('d-pad'));
    expect(text, contains('android/app/src/tv/AndroidManifest.xml'));
  });

  test('TV flavor manifest declares Leanback launcher and non-touch features', () {
    final manifest =
        File('android/app/src/tv/AndroidManifest.xml').readAsStringSync();
    expect(manifest, contains('TV-003'));
    expect(manifest, contains('android.software.leanback'));
    expect(manifest, contains('android:required="true"'));
    expect(manifest, contains('android.hardware.touchscreen'));
    expect(manifest, contains('android:required="false"'));
    expect(manifest, contains('LEANBACK_LAUNCHER'));
    expect(manifest, contains('@drawable/tv_banner'));
    // Leanback must be required=true (TV-only APK), not false.
    final leanbackBlock = RegExp(
      r'android\.software\.leanback"\s+android:required="(true|false)"',
      multiLine: true,
    ).firstMatch(manifest.replaceAll('\r\n', '\n'));
    expect(leanbackBlock, isNotNull);
    expect(leanbackBlock!.group(1), 'true');
  });

  test('main manifest does not own TV banner; drawable exists at 320x180 path', () {
    final main =
        File('android/app/src/main/AndroidManifest.xml').readAsStringSync();
    expect(main.contains('android:banner='), isFalse);
    expect(
      File('android/app/src/main/res/drawable/tv_banner.png').existsSync(),
      isTrue,
    );
    expect(File('assets/brand/tv_banner_320x180.png').existsSync(), isTrue);
  });
}
