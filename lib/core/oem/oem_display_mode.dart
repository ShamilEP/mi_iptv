/// Preferred display mode hint for TV surfaces (TV-011).
final class OemDisplayMode {
  const OemDisplayMode({
    required this.width,
    required this.height,
    this.refreshRateHz = 60,
    this.preferHdr = false,
  });

  /// MVP certification canvas (QA-002 P0).
  static const OemDisplayMode fullHd60 = OemDisplayMode(
    width: 1920,
    height: 1080,
    refreshRateHz: 60,
  );

  /// Optional high-end smoke target (QA-002 P1).
  static const OemDisplayMode uhd60 = OemDisplayMode(
    width: 3840,
    height: 2160,
    refreshRateHz: 60,
    preferHdr: true,
  );

  final int width;
  final int height;
  final int refreshRateHz;
  final bool preferHdr;
}
