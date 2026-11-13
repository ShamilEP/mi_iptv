import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('TV-052 doc locks audio focus, wake, lifecycle, HDMI', () {
    final file = File('docs/architecture/tv-052-playback-session-lifecycle.md');
    expect(file.existsSync(), isTrue);
    final text = file.readAsStringSync();
    expect(text, contains('TV-052'));
    expect(text, contains('SRS §3'));
    expect(text, contains('audio focus'));
    expect(text, contains('KEEP_SCREEN_ON'));
    expect(text, contains('background'));
    expect(text, contains('HDMI'));
    expect(text, contains('PlaybackSessionCoordinator'));
    expect(text, contains('PlaybackSessionPlugin'));
    expect(text, contains('TV-050'));
  });

  test('native PlaybackSessionPlugin is registered in MainActivity', () {
    expect(
      File(
        'android/app/src/main/kotlin/com/example/mi_iptv/player/PlaybackSessionPlugin.kt',
      ).existsSync(),
      isTrue,
    );
    final main = File(
      'android/app/src/main/kotlin/com/example/mi_iptv/MainActivity.kt',
    ).readAsStringSync();
    expect(main, contains('PlaybackSessionPlugin'));
  });
}
