import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/oem/oem_compatibility_profile.dart';
import 'package:mi_iptv/core/oem/oem_decoder_capabilities.dart';
import 'package:mi_iptv/core/oem/oem_display_mode.dart';
import 'package:mi_iptv/core/oem/oem_manufacturer.dart';
import 'package:mi_iptv/core/oem/oem_quirk.dart';
import 'package:mi_iptv/features/player/domain/entities/playback_mode.dart';
import 'package:mi_iptv/features/player/domain/services/abr_buffer_policy.dart';

void main() {
  group('TV-053 ABR / buffer policy', () {
    test('live uses shorter buffers than VOD', () {
      const policy = AbrBufferPolicy.defaults;
      final live = policy.resolve(PlaybackMode.live);
      final vod = policy.resolve(PlaybackMode.vod);

      expect(live.maxBufferMs, lessThan(vod.maxBufferMs));
      expect(live.minBufferMs, lessThan(vod.minBufferMs));
      expect(live.mode, PlaybackMode.live);
      expect(vod.mode, PlaybackMode.vod);
    });

    test('OEM conservativeAbr lowers fraction and raises upswitch hold', () {
      const oem = OemCompatibilityProfile(
        manufacturer: OemManufacturer.google,
        decoder: OemDecoderCapabilities.lowMemory,
        displayMode: OemDisplayMode.fullHd60,
        quirks: {
          OemQuirk.conservativeAbr,
          OemQuirk.prefer1080pCeiling,
        },
      );
      final live = AbrBufferPolicy(oem: oem).resolve(PlaybackMode.live);
      final baseline = AbrBufferPolicy.defaults.resolve(PlaybackMode.live);

      expect(live.conservative, isTrue);
      expect(live.bandwidthFraction, lessThan(baseline.bandwidthFraction));
      expect(
        live.minDurationForQualityIncreaseMs,
        greaterThan(baseline.minDurationForQualityIncreaseMs),
      );
      expect(live.maxWidth, lessThanOrEqualTo(1920));
      expect(live.maxHeight, lessThanOrEqualTo(1080));
    });

    test('premium OEM allows 4K bitrate ceiling on VOD', () {
      const oem = OemCompatibilityProfile(
        manufacturer: OemManufacturer.nvidia,
        decoder: OemDecoderCapabilities.premium,
        displayMode: OemDisplayMode.uhd60,
      );
      final vod = AbrBufferPolicy(oem: oem).resolve(PlaybackMode.vod);
      expect(vod.maxWidth, 3840);
      expect(vod.maxHeight, 2160);
      expect(vod.maxVideoBitrateBps, greaterThanOrEqualTo(10000000));
    });

    test('wire map exposes LoadControl / ABR knobs', () {
      final wire = AbrBufferPolicy.defaults.resolve(PlaybackMode.vod).toWire();
      expect(wire['mode'], 'vod');
      expect(wire['minBufferMs'], isA<int>());
      expect(wire['maxVideoBitrateBps'], isA<int>());
      expect(wire['bandwidthFraction'], isA<double>());
    });
  });
}
