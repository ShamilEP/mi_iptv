import 'package:flutter/widgets.dart';

/// Brand motion durations and curves (DSN-004 / DSN-020).
///
/// Focus scale remains [FocusStyles.scale]; this class owns time + curves and
/// reduced-motion resolution. Prefer [durationOf] in animated widgets.
abstract final class AppMotion {
  static const Duration fast = Duration(milliseconds: 120);
  static const Duration normal = Duration(milliseconds: 200);
  static const Duration slow = Duration(milliseconds: 320);

  /// Channel info overlay auto-hide (DSN-015 / SRS §13).
  ///
  /// Functional dwell time — not a decorative animation; still honored when
  /// [reduceMotion] is true (content still auto-dismisses).
  static const Duration channelInfoAutoHide = Duration(seconds: 4);

  /// VOD player controls temporary overlay auto-hide (DSN-037).
  static const Duration playerControlsAutoHide = Duration(seconds: 4);

  /// Splash identity hold before advancing (DSN-030). Keep short — not a
  /// decorative intro sequence.
  static const Duration splashHold = Duration(milliseconds: 600);

  static const Curve emphasized = Curves.easeOutCubic;
  static const Curve standard = Curves.easeInOut;

  /// True when the platform / accessibility setting disables animations.
  static bool reduceMotion(BuildContext context) =>
      MediaQuery.disableAnimationsOf(context);

  /// Returns [preferred] unless reduced motion is on — then [Duration.zero].
  static Duration durationOf(BuildContext context, Duration preferred) =>
      reduceMotion(context) ? Duration.zero : preferred;

  /// Curve for animated transitions; snaps with [Curves.linear] under reduce.
  static Curve curveOf(BuildContext context, Curve preferred) =>
      reduceMotion(context) ? Curves.linear : preferred;
}
