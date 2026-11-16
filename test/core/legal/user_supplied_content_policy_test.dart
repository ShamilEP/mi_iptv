import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/legal/user_supplied_content_policy.dart';

void main() {
  group('SEC-043 draft user-supplied content policy', () {
    test('stays draft with no invented takedown mailbox', () {
      expect(UserSuppliedContentPolicy.isDraft, isTrue);
      expect(UserSuppliedContentPolicy.hasPublishedTakedownContact, isFalse);
      expect(UserSuppliedContentPolicy.takedownContactUri, isNull);
      expect(
        UserSuppliedContentPolicy.shortProductStance.toLowerCase(),
        contains('responsible'),
      );
      expect(
        UserSuppliedContentPolicy.draftBanner.toLowerCase(),
        contains('draft'),
      );
    });

    test('draft ToS doc exists and flags Product ownership', () {
      final file = File(UserSuppliedContentPolicy.draftDocPath);
      expect(file.existsSync(), isTrue);
      final text = file.readAsStringSync();
      expect(text, contains('DRAFT'));
      expect(text, contains('SEC-043'));
      expect(text, contains('PRD-040'));
      expect(text, contains('takedown'));
      expect(text, contains('M3U'));
      expect(text, isNot(contains('takedown@mi-iptv.com')));
    });
  });
}
