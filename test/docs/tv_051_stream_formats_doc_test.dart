import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('TV-051 doc maps sniffing, headers, redirects, and formats', () {
    final file = File('docs/architecture/tv-051-stream-formats.md');
    expect(file.existsSync(), isTrue);
    final text = file.readAsStringSync();
    expect(text, contains('TV-051'));
    expect(text, contains('TV-050'));
    expect(text, contains('HLS'));
    expect(text, contains('DASH'));
    expect(text, contains('progressive'));
    expect(text, contains('StreamFormatSniffer'));
    expect(text, contains('PlaybackRequest'));
    expect(text, contains('headers'));
    expect(text, contains('User-Agent'));
    expect(text, contains('redirect'));
    expect(text, contains('AllowCrossProtocolRedirects'));
  });

  test('native Media3 engine enables redirects and mime hints', () {
    final engine = File(
      'android/app/src/main/kotlin/com/example/mi_iptv/player/Media3PlayerEngine.kt',
    ).readAsStringSync();
    expect(engine, contains('setAllowCrossProtocolRedirects(true)'));
    expect(engine, contains('APPLICATION_M3U8'));
    expect(engine, contains('APPLICATION_MPD'));
    expect(engine, contains('VIDEO_MP2T'));
    expect(engine, contains('VIDEO_MP4'));
    expect(engine, contains('setDefaultRequestProperties'));
    expect(engine, contains('setUserAgent'));

    final gradle = File('android/app/build.gradle.kts').readAsStringSync();
    expect(gradle, contains('media3-exoplayer-hls'));
    expect(gradle, contains('media3-exoplayer-dash'));
    expect(gradle, contains('media3-datasource'));
  });
}
