import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/theme/brand_assets.dart';

void main() {
  group('BrandAssets DSN-005 contract', () {
    test('locks viewBox and stroke geometry', () {
      expect(BrandAssets.viewBoxWidth, 72);
      expect(BrandAssets.viewBoxHeight, 64);
      expect(BrandAssets.strokeWidth, 7);
      expect(BrandAssets.liveDotRadius, 5.5);
    });

    test('clear space equals live-dot diameter', () {
      expect(BrandAssets.clearSpaceUnit, BrandAssets.liveDotRadius * 2);
      expect(BrandAssets.clearSpaceUnit, 11);
    });

    test('locks minimum mark size and wordmark rules', () {
      expect(BrandAssets.minMarkSize, 24);
      expect(BrandAssets.wordmarkText, 'iptv');
      expect(BrandAssets.wordmarkTrackingEm, -0.03);
    });

    test('exposes kit asset paths under assets/brand', () {
      expect(BrandAssets.markSvg, startsWith('assets/brand/'));
      expect(BrandAssets.appIcon512, endsWith('app_icon_512.png'));
      expect(BrandAssets.tvBanner, endsWith('tv_banner_320x180.png'));
    });
  });
}
