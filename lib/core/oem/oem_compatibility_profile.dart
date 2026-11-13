import 'oem_decoder_capabilities.dart';
import 'oem_display_mode.dart';
import 'oem_manufacturer.dart';
import 'oem_quirk.dart';

/// Resolved OEM compatibility bundle (TV-011 / NFR-009).
final class OemCompatibilityProfile {
  const OemCompatibilityProfile({
    required this.manufacturer,
    required this.decoder,
    required this.displayMode,
    this.quirks = const <OemQuirk>{},
  });

  final OemManufacturer manufacturer;
  final OemDecoderCapabilities decoder;
  final OemDisplayMode displayMode;
  final Set<OemQuirk> quirks;

  bool hasQuirk(OemQuirk quirk) => quirks.contains(quirk);
}
