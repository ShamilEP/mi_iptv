/// Known Android TV / Google TV OEM groups (TV-011 / NFR-009 / QA-002).
enum OemManufacturer {
  google,
  sony,
  tcl,
  hisense,
  nvidia,
  unknown,
}

/// Parses manufacturer strings from `Build.MANUFACTURER` / model tags.
abstract final class OemManufacturerParser {
  static OemManufacturer parse(String? raw) {
    final value = (raw ?? '').trim().toLowerCase();
    if (value.isEmpty) return OemManufacturer.unknown;
    if (value.contains('google') || value.contains('chromecast')) {
      return OemManufacturer.google;
    }
    if (value.contains('sony') || value.contains('bravia')) {
      return OemManufacturer.sony;
    }
    if (value.contains('tcl')) return OemManufacturer.tcl;
    if (value.contains('hisense')) return OemManufacturer.hisense;
    if (value.contains('nvidia') || value.contains('shield')) {
      return OemManufacturer.nvidia;
    }
    return OemManufacturer.unknown;
  }
}
