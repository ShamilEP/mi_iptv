import 'oem_compatibility_profile.dart';
import 'oem_decoder_capabilities.dart';
import 'oem_device_identity.dart';
import 'oem_display_mode.dart';
import 'oem_manufacturer.dart';
import 'oem_quirk.dart';

/// Static OEM profiles aligned with the QA-002 device matrix (TV-011).
abstract final class OemProfileCatalog {
  static OemCompatibilityProfile resolve(OemDeviceIdentity identity) {
    return switch (identity.manufacturer) {
      OemManufacturer.google => _google(identity),
      OemManufacturer.sony => const OemCompatibilityProfile(
          manufacturer: OemManufacturer.sony,
          decoder: OemDecoderCapabilities.midRange,
          displayMode: OemDisplayMode.fullHd60,
          quirks: {
            OemQuirk.pageKeysAsChannel,
            OemQuirk.debounceDuplicateBack,
          },
        ),
      OemManufacturer.tcl || OemManufacturer.hisense => OemCompatibilityProfile(
          manufacturer: identity.manufacturer,
          decoder: OemDecoderCapabilities.midRange,
          displayMode: OemDisplayMode.fullHd60,
          quirks: const {
            OemQuirk.pageKeysAsChannel,
          },
        ),
      OemManufacturer.nvidia => const OemCompatibilityProfile(
          manufacturer: OemManufacturer.nvidia,
          decoder: OemDecoderCapabilities.premium,
          displayMode: OemDisplayMode.uhd60,
        ),
      OemManufacturer.unknown => const OemCompatibilityProfile(
          manufacturer: OemManufacturer.unknown,
          decoder: OemDecoderCapabilities.midRange,
          displayMode: OemDisplayMode.fullHd60,
          quirks: {
            OemQuirk.prefer1080pCeiling,
            OemQuirk.conservativeAbr,
          },
        ),
    };
  }

  static OemCompatibilityProfile _google(OemDeviceIdentity identity) {
    final model = identity.model.toLowerCase();
    final lowMemory = model.contains('hd') && !model.contains('4k');
    if (lowMemory) {
      return const OemCompatibilityProfile(
        manufacturer: OemManufacturer.google,
        decoder: OemDecoderCapabilities.lowMemory,
        displayMode: OemDisplayMode.fullHd60,
        quirks: {
          OemQuirk.prefer1080pCeiling,
          OemQuirk.conservativeAbr,
        },
      );
    }
    return const OemCompatibilityProfile(
      manufacturer: OemManufacturer.google,
      decoder: OemDecoderCapabilities.midRange,
      displayMode: OemDisplayMode.fullHd60,
    );
  }
}
