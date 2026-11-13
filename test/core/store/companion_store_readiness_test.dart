import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/store/companion_store_readiness.dart';

void main() {
  group('CMP-010 Companion store readiness', () {
    test('icons point at DSN-005 brand masters that exist', () {
      expect(CompanionStoreReadiness.iconAssetPaths, isNotEmpty);
      for (final path in CompanionStoreReadiness.iconAssetPaths) {
        expect(File(path).existsSync(), isTrue, reason: path);
      }
    });

    test('Android permissions inventory is INTERNET-only', () {
      expect(
        CompanionStoreReadiness.androidPermissions,
        <String>['android.permission.INTERNET'],
      );
      expect(CompanionStoreReadiness.iosUsageDescriptions, isEmpty);
    });

    test('privacy categories declare no advertising tracking', () {
      final ads = CompanionStoreReadiness.privacyDataCategories
          .singleWhere((c) => c.id == 'advertising');
      expect(ads.collected, isFalse);
      expect(
        CompanionStoreReadiness.reviewerNotes.toLowerCase(),
        contains('staging'),
      );
      expect(CompanionStoreReadiness.reviewerNotes, isNot(contains('password=')));
    });

    test('main AndroidManifest declares INTERNET for release', () {
      final manifest =
          File('android/app/src/main/AndroidManifest.xml').readAsStringSync();
      expect(
        manifest,
        contains('android.permission.INTERNET'),
      );
    });

    test('iOS Info.plist has Companion display name and export compliance', () {
      final plist = File('ios/Runner/Info.plist').readAsStringSync();
      expect(plist, contains('Mi IPTV Companion'));
      expect(plist, contains('ITSAppUsesNonExemptEncryption'));
      expect(File('ios/Runner/PrivacyInfo.xcprivacy').existsSync(), isTrue);
    });
  });
}
