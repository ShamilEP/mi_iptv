import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('TV-010 doc locks detection, offline UI, and cached browse', () {
    final doc =
        File('docs/architecture/tv-010-connectivity-offline.md').readAsStringSync();
    expect(doc, contains('TV-010'));
    expect(doc, contains('ConnectivityMonitor'));
    expect(doc, contains('OfflineBanner'));
    expect(doc, contains('offlineCached'));
    expect(doc, contains('LocalMediaStore'));
    expect(doc, contains('NFR-004'));
    expect(doc, contains('QA-039'));
    expect(doc, contains('connectivity_plus'));
  });
}
