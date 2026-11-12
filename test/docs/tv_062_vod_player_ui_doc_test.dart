import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('TV-062 doc maps timeline, seek, accelerated seek, volume, exit', () {
    final file = File('docs/architecture/tv-062-vod-player-ui.md');
    expect(file.existsSync(), isTrue);
    final text = file.readAsStringSync();
    expect(text, contains('TV-062'));
    expect(text, contains('DSN-037'));
    expect(text, contains('TV-050'));
    expect(text, contains('TvVodPlayerPage'));
    expect(text, contains('AcceleratedSeek'));
    expect(text, contains('VodTransportSession'));
    expect(text, contains('timeline'));
    expect(text, contains('play/pause'));
    expect(text, contains('volume'));
    expect(text, contains('Exit'));
    expect(text, contains('FR-014'));
  });
}
