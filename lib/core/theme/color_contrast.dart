import 'dart:ui';

/// WCAG contrast helpers for Brand Theme 2026–27 pair audits.
abstract final class ColorContrast {
  /// Relative luminance in \[0, 1\] (WCAG / [Color.computeLuminance]).
  static double relativeLuminance(Color color) => color.computeLuminance();

  /// Contrast ratio between [a] and [b] (WCAG 2.x), always ≥ 1.
  static double contrastRatio(Color a, Color b) {
    final la = relativeLuminance(a);
    final lb = relativeLuminance(b);
    final lighter = la > lb ? la : lb;
    final darker = la > lb ? lb : la;
    return (lighter + 0.05) / (darker + 0.05);
  }

  /// WCAG AA: 4.5:1 normal text, 3.0:1 large text.
  static bool meetsWcagAa(
    Color foreground,
    Color background, {
    bool largeText = false,
  }) {
    final minRatio = largeText ? 3.0 : 4.5;
    return contrastRatio(foreground, background) >= minRatio;
  }
}
