import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('TV-056 doc maps mute/volume preservation to NFR-QOE-06', () {
    final file = File('docs/architecture/tv-056-handle-audio-state.md');
    expect(file.existsSync(), isTrue);
    final text = file.readAsStringSync();
    expect(text, contains('TV-056'));
    expect(text, contains('TV-050'));
    expect(text, contains('NFR-QOE-06'));
    expect(text, contains('PlaybackAudioState'));
    expect(text, contains('setAudioState'));
    expect(text, contains('mute'));
    expect(text, contains('volume'));
  });
}
