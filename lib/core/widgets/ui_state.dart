/// The 12 mandatory interaction / content states (DSN-010 / SRS §20).
///
/// Every TV and Companion component must support these. Prefer
/// [UiStateCatalog] for labels and non-color cues — state ≠ hue alone.
///
/// Enum member [defaults] maps to the product label **Default** (`default`
/// is reserved in Dart).
enum UiState {
  /// Resting, interactive, no highlight.
  defaults,

  /// D-pad / keyboard focus (see [FocusStyles]).
  focused,

  /// Momentary activate / click.
  pressed,

  /// Not interactive.
  disabled,

  /// Async in flight (fetch, buffer start).
  loading,

  /// No items / no content yet.
  empty,

  /// Failure that needs attention.
  error,

  /// No network / unreachable backend.
  offline,

  /// Media actively playing.
  playing,

  /// Chosen among peers (row, chip, source).
  selected,

  /// Multi-device or catalog sync in progress.
  syncing,

  /// Sync LWW / conflict needs user action.
  syncConflict,
}
