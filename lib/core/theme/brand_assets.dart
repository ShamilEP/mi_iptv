/// DSN-005 logo kit constants and asset paths.
///
/// Clear space equals the live-dot diameter. Prefer [BrandMark] /
/// [BrandWordmark] / [BrandLockup] over inventing logo art in widgets.
abstract final class BrandAssets {
  /// Canonical mark viewBox width.
  static const double viewBoxWidth = 72;

  /// Canonical mark viewBox height.
  static const double viewBoxHeight = 64;

  /// Live-dot radius in viewBox units (diameter = [clearSpaceUnit]).
  static const double liveDotRadius = 5.5;

  /// Clear space around the mark (= live-dot diameter).
  static const double clearSpaceUnit = liveDotRadius * 2;

  /// Minimum rendered mark height in logical pixels.
  static const double minMarkSize = 24;

  /// Wordmark tracking as a fraction of font size (−3%).
  static const double wordmarkTrackingEm = -0.03;

  /// Wordmark glyph string (always lowercase).
  static const String wordmarkText = 'iptv';

  /// Stroke width in viewBox units.
  static const double strokeWidth = 7;

  static const String markSvg = 'assets/brand/mark.svg';
  static const String markCompanionSvg = 'assets/brand/mark_companion.svg';
  static const String markMonochromeSvg = 'assets/brand/mark_monochrome.svg';
  static const String appIcon512 = 'assets/brand/app_icon_512.png';
  static const String tvBanner = 'assets/brand/tv_banner_320x180.png';
  static const String lockupDark = 'assets/brand/lockup_dark.png';
  static const String lockupCompanion = 'assets/brand/lockup_companion.png';
  static const String lockupMonochrome = 'assets/brand/lockup_monochrome.png';
}

/// Color tone for the brand mark / lockup.
enum BrandMarkTone {
  /// Signal stroke + Ember live-dot (TV / dark).
  dark,

  /// Companion primary + companion live (light surfaces).
  companion,

  /// Single-color Ink mark (for Signal fills / mono plates).
  monochrome,
}
