import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/store/companion_store_readiness.dart';
import 'package:mi_iptv/core/store/store_compliance.dart';
import 'package:mi_iptv/core/theme/app_overscan.dart';
import 'package:mi_iptv/core/theme/focus_styles.dart';

void main() {
  group('QA-052 store compliance', () {
    test('checklist covers Play TV and App Store / Play Companion', () {
      expect(StoreCompliance.playTvQualityChecks, isNotEmpty);
      expect(StoreCompliance.appStorePlayCompanionChecks, isNotEmpty);
      final ids = StoreCompliance.allChecks.map((c) => c.id).toSet();
      expect(ids, containsAll(<String>[
        'leanback_packaging',
        'dpad_focus',
        'overscan',
        'legibility',
        'companion_privacy',
        'prd_042_listing',
      ]));
      expect(
        StoreCompliance.appStorePlayCompanionChecks
            .singleWhere((c) => c.id == 'prd_042_listing')
            .automated,
        isFalse,
      );
    });

    test('Play TV manifest meets Leanback packaging guidelines', () {
      final manifest =
          File(StoreCompliance.tvManifestPath).readAsStringSync();
      for (final token in StoreCompliance.playTvManifestRequirements) {
        expect(manifest, contains(token), reason: token);
      }
      expect(manifest, contains('android:required="false"'));
      expect(manifest, contains('android.software.leanback'));
      expect(
        manifest,
        contains('android:required="true"'),
        reason: 'leanback feature required for TV-only APK',
      );
    });

    test('TV banner assets are 320×180 PNG masters', () {
      for (final path in <String>[
        StoreCompliance.tvBannerDrawablePath,
        StoreCompliance.tvBannerBrandPath,
      ]) {
        final file = File(path);
        expect(file.existsSync(), isTrue, reason: path);
        final size = _pngSize(file.readAsBytesSync());
        expect(size.$1, StoreCompliance.tvBannerWidthPx, reason: path);
        expect(size.$2, StoreCompliance.tvBannerHeightPx, reason: path);
      }
    });

    test('focus and overscan contracts remain store-quality locked', () {
      expect(FocusStyles.ringWidth, 4);
      expect(FocusStyles.scale, 1.05);
      expect(AppOverscan.inset, greaterThan(0));
      expect(
        StoreCompliance.reviewerNotes.toLowerCase(),
        contains('d-pad'),
      );
      expect(StoreCompliance.reviewerNotes, contains('PRD-042'));
      expect(StoreCompliance.reviewerNotes, isNot(contains('password=')));
    });

    test('Companion readiness still satisfies App Store / Play privacy bar', () {
      expect(CompanionStoreReadiness.androidPermissions, [
        'android.permission.INTERNET',
      ]);
      expect(CompanionStoreReadiness.iosUsageDescriptions, isEmpty);
      final ads = CompanionStoreReadiness.privacyDataCategories
          .singleWhere((c) => c.id == 'advertising');
      expect(ads.collected, isFalse);
      expect(
        CompanionStoreReadiness.reviewerNotes.toLowerCase(),
        contains('no local video player'),
      );
      for (final path in CompanionStoreReadiness.iconAssetPaths) {
        expect(File(path).existsSync(), isTrue, reason: path);
      }
    });
  });
}

/// Reads width/height from a PNG IHDR chunk (no third-party package).
(int, int) _pngSize(Uint8List bytes) {
  // Signature (8) + IHDR length (4) + 'IHDR' (4) + width (4) + height (4)
  expect(bytes.length, greaterThanOrEqualTo(24));
  expect(bytes.sublist(0, 8), <int>[137, 80, 78, 71, 13, 10, 26, 10]);
  final bd = ByteData.sublistView(bytes);
  final width = bd.getUint32(16);
  final height = bd.getUint32(20);
  return (width, height);
}
