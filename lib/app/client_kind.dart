/// Which Flutter client surface is running (PRD-011 / CMP-001).
///
/// TV and Companion share one Dart package (`mi_iptv`) and the same domain
/// layer; only presentation and theme differ.
enum ClientKind {
  /// Android TV / Google TV Leanback-oriented surface.
  tv,

  /// Phone/tablet companion (Android + iOS) — no local video in MVP.
  companion,
}
