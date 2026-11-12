import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('TV-007 doc covers cache buckets and Drift adapter', () {
    final file = File('docs/architecture/tv-007-local-persistence.md');
    expect(file.existsSync(), isTrue);
    final text = file.readAsStringSync();
    expect(text, contains('TV-007'));
    expect(text, contains('LocalMediaStore'));
    expect(text, contains('DriftLocalMediaStore'));
    expect(text.toLowerCase(), contains('channels'));
    expect(text, contains('VOD'));
    expect(text.toLowerCase(), contains('playback'));
    expect(text.toLowerCase(), contains('favorites'));
    expect(text.toLowerCase(), contains('sources'));
    expect(text.toLowerCase(), contains('settings'));
    expect(text.toLowerCase(), contains('outbox'));
    expect(text.toLowerCase(), contains('drift'));
    expect(text.toLowerCase(), contains('no passwords'));
    expect(text, contains('bootstrap'));
  });
}
