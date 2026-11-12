import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('TV-054 doc maps taxonomy, backoff, and coordinator', () {
    final file = File('docs/architecture/tv-054-error-taxonomy-retry.md');
    expect(file.existsSync(), isTrue);
    final text = file.readAsStringSync();
    expect(text, contains('TV-054'));
    expect(text, contains('TV-050'));
    expect(text, contains('network'));
    expect(text, contains('source'));
    expect(text, contains('decoder'));
    expect(text, contains('PlaybackErrorClassifier'));
    expect(text, contains('PlaybackRetryPolicy'));
    expect(text, contains('PlaybackRetryCoordinator'));
    expect(text, contains('maxAttempts'));
    expect(text, contains('exponential'));
    expect(text, contains('FR-016'));
  });
}
