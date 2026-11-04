/// Brand spacing scale and grid gutters (DSN-004).
///
/// 4dp base; 8-forward for TV 10-foot readability. Prefer named tokens over
/// raw numbers in widgets.
abstract final class AppSpacing {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double xxxl = 64;

  /// Tight vertical stack (e.g. title → subtitle).
  static const double stackTight = xs;

  /// Default section / stack gap.
  static const double stack = lg;

  /// Inner padding for cards and focusable tiles.
  static const double insetCard = md;

  /// TV page inset (matches [AppOverscan.inset]).
  static const double insetPageTv = xxl;

  /// Companion content inset (pair with system [SafeArea]).
  static const double insetPageCompanion = md;
}

/// Home / catalog grid rhythm (DSN-004).
abstract final class AppGrid {
  /// Card-to-card gap within a horizontal rail.
  static const double gutter = AppSpacing.md;

  /// Vertical gap between Home content rows.
  static const double rowGap = AppSpacing.lg;

  /// Sidebar / nav rail ↔ main content gap.
  static const double railGap = AppSpacing.xl;
}
