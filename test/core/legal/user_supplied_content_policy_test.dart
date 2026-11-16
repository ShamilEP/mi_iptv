import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/legal/user_supplied_content_policy.dart';

void main() {
  group('SEC-043 user-supplied content policy', () {
    test('publishes Product takedown contact while ToS body stays draft', () {
      expect(UserSuppliedContentPolicy.isDraft, isTrue);
      expect(UserSuppliedContentPolicy.hasPublishedTakedownContact, isTrue);
      expect(
        UserSuppliedContentPolicy.takedownContactEmail,
        'shamil.espinosa@gmail.com',
      );
      expect(
        UserSuppliedContentPolicy.takedownContactUri,
        'mailto:shamil.espinosa@gmail.com',
      );
      expect(
        UserSuppliedContentPolicy.shortProductStance.toLowerCase(),
        contains('responsible'),
      );
      expect(
        UserSuppliedContentPolicy.draftBanner.toLowerCase(),
        contains('draft'),
      );
    });

    test('draft ToS doc records SEC-043 contact and Product ownership', () {
      final file = File(UserSuppliedContentPolicy.draftDocPath);
      expect(file.existsSync(), isTrue);
      final text = file.readAsStringSync();
      expect(text, contains('DRAFT'));
      expect(text, contains('SEC-043'));
      expect(text, contains('PRD-040'));
      expect(text, contains('takedown'));
      expect(text, contains('M3U'));
      expect(text, contains('shamil.espinosa@gmail.com'));
      expect(text, isNot(contains('takedown@<PRODUCT-DOMAIN>')));
    });
  });
}
