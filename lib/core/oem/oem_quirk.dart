/// Manufacturer / SoC behavioral flags (TV-011 / NFR-009).
enum OemQuirk {
  /// Map PageUp/PageDown and media track keys to CH+/CH−.
  pageKeysAsChannel,

  /// Prefer conservative 1080p decode ceilings (low-memory sticks).
  prefer1080pCeiling,

  /// Prefer longer ABR ramp / avoid aggressive 4K switches (thermal sticks).
  conservativeAbr,

  /// HDMI-CEC / panel remotes may send duplicate Back — debounce dismiss.
  debounceDuplicateBack,
}
