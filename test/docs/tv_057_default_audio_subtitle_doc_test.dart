import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('TV-057 doc maps defaults and DSN-021 cues to FR-017 MVP', () {
    final file = File('docs/architecture/tv-057-default-audio-subtitle.md');
    expect(file.existsSync(), isTrue);
    final text = file.readAsStringSync();
    expect(text, contains('TV-057'));
    expect(text, contains('DSN-021'));
    expect(text, contains('TV-050'));
    expect(text, contains('FR-017'));
    expect(text, contains('DefaultTrackPolicy'));
    expect(text, contains('MiSubtitleCaption'));
    expect(text, contains('subtitleCue'));
    expect(text, contains('applySourceDefaultTracks'));
  });
}
