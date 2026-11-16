import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('TV-055 doc maps spinner UX to FR-016 and TV-054', () {
    final file = File('docs/architecture/tv-055-buffering-reconnect-ux.md');
    expect(file.existsSync(), isTrue);
    final text = file.readAsStringSync();
    expect(text, contains('TV-055'));
    expect(text, contains('DSN-016'));
    expect(text, contains('TV-054'));
    expect(text, contains('FR-016'));
    expect(text, contains('BufferingReconnectOverlay'));
    expect(text, contains('PlaybackStatusFeedback'));
    expect(text, contains('isRetrying'));
    expect(text, contains('Reconnecting'));
    expect(text, contains('Loading'));
  });
}
