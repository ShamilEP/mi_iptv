/// Home content surface states beyond the ready rails (TV-033 / DSN-017).
enum TvHomeSurfaceState {
  /// Continue watching / Featured / Live channels rails.
  ready,

  /// Account has no IPTV / catalog sources configured.
  noSources,

  /// Sources exist but the catalog has nothing to show.
  emptyCatalog,

  /// Device cannot reach the network / backend.
  offline,
}
