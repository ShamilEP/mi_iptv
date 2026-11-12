import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('TV-031 doc maps lazy load, skeletons, cues, focus, anchored list', () {
    final file = File('docs/architecture/tv-031-row-carousel.md');
    expect(file.existsSync(), isTrue);
    final text = file.readAsStringSync();
    expect(text, contains('TV-031'));
    expect(text, contains('DSN-012'));
    expect(text, contains('TV-004'));
    expect(text, contains('ContentRow'));
    expect(text, contains('ContentRowList'));
    expect(text, contains('onNearEnd'));
    expect(text, contains('placeholderCount'));
    expect(text, contains('ContentRowSkeleton'));
    expect(text, contains('position cue'));
    expect(text, contains('Last-focus memory'));
    expect(text, contains('rowCount'));
    expect(text, contains('infinite scroll'));
  });
}
