import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('TV-050 doc maps Media3 adapter, DI lifecycle, and native host', () {
    final file = File('docs/architecture/tv-050-media3-player.md');
    expect(file.existsSync(), isTrue);
    final text = file.readAsStringSync();
    expect(text, contains('TV-050'));
    expect(text, contains('PRD-003'));
    expect(text, contains('MediaPlayerController'));
    expect(text, contains('Media3PlayerAdapter'));
    expect(text, contains('AppDependencies'));
    expect(text, contains('Media3PlayerPlugin'));
    expect(text, contains('Media3PlayerEngine'));
    expect(text, contains('androidx.media3'));
    expect(text, contains('lifecycle'));
  });

  test('native Media3 sources and Gradle BOM exist', () {
    expect(
      File(
        'android/app/src/main/kotlin/com/example/mi_iptv/player/Media3PlayerPlugin.kt',
      ).existsSync(),
      isTrue,
    );
    expect(
      File(
        'android/app/src/main/kotlin/com/example/mi_iptv/player/Media3PlayerEngine.kt',
      ).existsSync(),
      isTrue,
    );
    final gradle = File('android/app/build.gradle.kts').readAsStringSync();
    expect(gradle, contains('media3-bom'));
    expect(gradle, contains('media3-exoplayer'));
  });
}
