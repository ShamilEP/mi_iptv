import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('TV-053 doc locks live/VOD buffers, OEM ABR, and Media3 wiring', () {
    final file = File('docs/architecture/tv-053-abr-buffering.md');
    expect(file.existsSync(), isTrue);
    final text = file.readAsStringSync();
    expect(text, contains('TV-053'));
    expect(text, contains('NFR-QOE-04'));
    expect(text, contains('AbrBufferPolicy'));
    expect(text, contains('PlaybackMode'));
    expect(text, contains('live'));
    expect(text, contains('VOD'));
    expect(text, contains('DefaultLoadControl'));
    expect(text, contains('DefaultTrackSelector'));
    expect(text, contains('TV-050'));
    expect(text, contains('TV-011'));
  });
}
