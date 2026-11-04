import 'package:flutter/animation.dart';

/// Brand motion durations and curves (DSN-004).
///
/// Focus scale remains [FocusStyles.scale]; this class owns time + curves only.
abstract final class AppMotion {
  static const Duration fast = Duration(milliseconds: 120);
  static const Duration normal = Duration(milliseconds: 200);
  static const Duration slow = Duration(milliseconds: 320);

  static const Curve emphasized = Curves.easeOutCubic;
  static const Curve standard = Curves.easeInOut;
}
