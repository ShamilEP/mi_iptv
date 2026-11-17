import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('CMP-050 doc locks Release 1 https scheme and Companion behavior', () {
    final file = File('docs/architecture/cmp-050-companion-deep-links.md');
    expect(file.existsSync(), isTrue);
    final text = file.readAsStringSync();
    expect(text, contains('CMP-050'));
    expect(text, contains('FR-030'));
    expect(text, contains('Release 1'));
    expect(text, contains('link.mi-iptv.app'));
    expect(text, contains('/vod/'));
    expect(text, contains('/live/'));
    expect(text, contains('DeepLinkParser'));
    expect(text, contains('CompanionDeepLinkBinder'));
  });
}
