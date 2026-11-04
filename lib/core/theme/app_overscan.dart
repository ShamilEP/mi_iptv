import 'package:flutter/painting.dart';

import 'app_spacing.dart';

/// TV overscan safe area (DSN-004).
///
/// ~5% of 1080p (~48 logical px). Keep actionable chrome and text inside this
/// box; full-bleed surfaces (player, hero art) may ignore it.
///
/// Companion uses Flutter [SafeArea] / [MediaQuery.padding] for notches — not
/// this class — plus [AppSpacing.insetPageCompanion] for content inset.
abstract final class AppOverscan {
  static const double inset = AppSpacing.xxl;

  static const EdgeInsets padding = EdgeInsets.all(inset);
}
