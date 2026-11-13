import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/images/artwork_uri.dart';
import 'package:mi_iptv/core/images/image_cache_controller.dart';
import 'package:mi_iptv/core/images/image_pipeline.dart';
import 'package:mi_iptv/core/images/image_pipeline_config.dart';
import 'package:mi_iptv/core/images/image_thumbnail_sizes.dart';
import 'package:mi_iptv/core/oem/oem_compatibility_profile.dart';
import 'package:mi_iptv/core/oem/oem_decoder_capabilities.dart';
import 'package:mi_iptv/core/oem/oem_display_mode.dart';
import 'package:mi_iptv/core/oem/oem_manufacturer.dart';
import 'package:mi_iptv/core/oem/oem_quirk.dart';
import 'package:mi_iptv/core/widgets/content_card_metrics.dart';

void main() {
  group('TV-012 image pipeline', () {
    test('applies memory ceilings to the cache controller', () {
      final cache = MemoryImageCacheController();
      final pipeline = ImagePipeline(
        config: ImagePipelineConfig.tvLowMemory,
        cache: cache,
      );

      expect(cache.maximumSize, ImagePipelineConfig.tvLowMemory.maximumSize);
      expect(
        cache.maximumSizeBytes,
        ImagePipelineConfig.tvLowMemory.maximumSizeBytes,
      );

      pipeline.apply(ImagePipelineConfig.tvDefault);
      expect(cache.maximumSize, ImagePipelineConfig.tvDefault.maximumSize);
      expect(
        cache.maximumSizeBytes,
        ImagePipelineConfig.tvDefault.maximumSizeBytes,
      );
    });

    test('OEM prefer1080pCeiling selects low-memory budget', () {
      const profile = OemCompatibilityProfile(
        manufacturer: OemManufacturer.google,
        decoder: OemDecoderCapabilities.lowMemory,
        displayMode: OemDisplayMode.fullHd60,
        quirks: {OemQuirk.prefer1080pCeiling},
      );
      expect(
        ImagePipelineConfig.forOem(profile),
        ImagePipelineConfig.tvLowMemory,
      );
    });

    test('thumbnail decode stays at card size × capped DPR', () {
      final size = ImageThumbnailSizes.decodePixelsFor(
        ContentCardKind.poster,
        config: ImagePipelineConfig.tvDefault,
        devicePixelRatio: 3,
      );
      final logical = ContentCardMetrics.sizeOf(ContentCardKind.poster);
      expect(size.width, logical.width * 2); // capped at 2.0
      expect(size.height, logical.height * 2);
    });

    test('releaseOffscreenImages clears live cache handles', () {
      final cache = MemoryImageCacheController()
        ..currentSize = 4
        ..currentSizeBytes = 1024;
      final pipeline = ImagePipeline(cache: cache);

      pipeline.releaseOffscreenImages();
      expect(cache.clearLiveCalls, 1);
      expect(cache.currentSize, 0);
    });

    test('providerFor wraps NetworkImage in ResizeImage', () {
      final pipeline = ImagePipeline(cache: MemoryImageCacheController());
      final provider = pipeline.providerFor(
        Uri.parse('https://cdn.example/poster.jpg'),
        cacheWidth: 160,
        cacheHeight: 240,
      );
      expect(provider, isA<ResizeImage>());
    });

    test('ArtworkUri accepts HTTPS and strips credentials', () {
      expect(ArtworkUri.tryParse(null), isNull);
      expect(ArtworkUri.tryParse('http://cdn.example/a.jpg'), isNull);
      expect(ArtworkUri.tryParse('not a url'), isNull);

      final clean = ArtworkUri.tryParse(
        'https://user:secret@cdn.example/a.jpg?x=1',
      );
      expect(clean, isNotNull);
      expect(clean!.scheme, 'https');
      expect(clean.userInfo, isEmpty);
      expect(clean.host, 'cdn.example');
      expect(clean.queryParameters['x'], '1');
    });
  });
}
