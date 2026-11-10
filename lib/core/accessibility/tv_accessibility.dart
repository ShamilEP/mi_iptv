import 'package:flutter/material.dart';

/// TV accessibility policy for OS text-size handling (DSN-021 / NFR-007).
///
/// Android TV / Google TV may expose font scale via system settings. Captions
/// and chrome honor scaling within a tighter band than Companion so 10-foot
/// layouts stay usable.
abstract final class TvAccessibility {
  /// Lowest OS text scale the TV shell honors.
  static const double minTextScale = 1.0;

  /// Highest OS text scale before layout clamping.
  static const double maxTextScale = 1.5;

  /// Clamp OS text scaling into the TV-supported range.
  static TextScaler clampTextScaler(TextScaler scaler) {
    return scaler.clamp(
      minScaleFactor: minTextScale,
      maxScaleFactor: maxTextScale,
    );
  }
}

/// Applies [TvAccessibility.clampTextScaler] under [MediaQuery].
class TvAccessibleScope extends StatelessWidget {
  const TvAccessibleScope({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return MediaQuery(
      data: media.copyWith(
        textScaler: TvAccessibility.clampTextScaler(media.textScaler),
      ),
      child: child,
    );
  }
}
