/// Declared decode envelope for the active OEM/SoC class (TV-011).
///
/// Soft guidance for player / ABR — not a MediaCodec enumeration dump.
final class OemDecoderCapabilities {
  const OemDecoderCapabilities({
    required this.maxWidth,
    required this.maxHeight,
    this.supportsHevc = true,
    this.supportsHdr10 = false,
    this.supportsAc3 = false,
    this.widevineL3 = true,
  });

  /// Mid-range Google TV / stick default (QA-002 M tier).
  static const OemDecoderCapabilities midRange = OemDecoderCapabilities(
    maxWidth: 1920,
    maxHeight: 1080,
    supportsHevc: true,
    supportsHdr10: false,
    supportsAc3: true,
  );

  /// Low-memory stick class (QA-002 L tier).
  static const OemDecoderCapabilities lowMemory = OemDecoderCapabilities(
    maxWidth: 1920,
    maxHeight: 1080,
    supportsHevc: true,
    supportsHdr10: false,
    supportsAc3: false,
  );

  /// Premium box / panel (QA-002 H tier).
  static const OemDecoderCapabilities premium = OemDecoderCapabilities(
    maxWidth: 3840,
    maxHeight: 2160,
    supportsHevc: true,
    supportsHdr10: true,
    supportsAc3: true,
  );

  final int maxWidth;
  final int maxHeight;
  final bool supportsHevc;
  final bool supportsHdr10;
  final bool supportsAc3;

  /// MVP DRM floor (PRD-003) — ClearKey + Widevine L3.
  final bool widevineL3;
}
