import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('QA-042 doc maps 24h soak, leaks, and NFR-003 budgets', () {
    final file = File('docs/qa/live_playback_soak.md');
    expect(file.existsSync(), isTrue);
    final text = file.readAsStringSync();
    expect(text, contains('QA-042'));
    expect(text, contains('NFR-003'));
    expect(text, contains('QA-002'));
    expect(text, contains('24'));
    expect(text, contains('live_playback_soak_test.dart'));
    expect(text, contains('PlaybackSessionCoordinator'));
    expect(text, contains('tvLowMemory'));
    expect(text, contains('accelerated'));
  });
}
