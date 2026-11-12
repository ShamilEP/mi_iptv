/// Directional D-pad edges and Back / restore rules for one TV screen (DSN-040).
enum TvFocusScreen {
  splash,
  onboardingAuth,
  home,
  liveTv,
  liveTvStreamFailure,
  search,
  favorites,
  contentDetail,
  settings,
  vodPlayer,
}

/// One focusable control in a screen focus map.
class TvFocusNodeSpec {
  const TvFocusNodeSpec({required this.id, required this.label});

  final String id;
  final String label;
}

/// Explicit up/down/left/right targets from a node (`null` = edge of map).
class TvFocusTraversal {
  const TvFocusTraversal({
    required this.fromId,
    this.up,
    this.down,
    this.left,
    this.right,
  });

  final String fromId;
  final String? up;
  final String? down;
  final String? left;
  final String? right;
}

/// Back key policy for a screen.
enum TvFocusBackBehavior {
  /// Splash has no interactive Back; hold completes startup.
  none,

  /// Leave the screen / pop the route.
  exitScreen,

  /// Collapse an overlay or panel and restore prior focus.
  dismissOverlay,

  /// Move focus to a named node without leaving the screen.
  moveFocus,
}

/// Locked focus map for one TV surface (SRS §12 / DSN-040).
class TvFocusMap {
  const TvFocusMap({
    required this.screen,
    required this.title,
    required this.firstFocusId,
    required this.nodes,
    required this.traversals,
    required this.backBehavior,
    this.backTargetId,
    this.restoreFocusId,
    this.notes = '',
  });

  final TvFocusScreen screen;
  final String title;

  /// Node that receives focus when the screen opens.
  final String firstFocusId;

  final List<TvFocusNodeSpec> nodes;
  final List<TvFocusTraversal> traversals;
  final TvFocusBackBehavior backBehavior;

  /// Optional Back destination node (e.g. dismiss action or move-focus target).
  final String? backTargetId;

  /// Node restored when returning to this screen from a child.
  final String? restoreFocusId;

  final String notes;

  TvFocusNodeSpec get firstFocus => nodeById(firstFocusId);

  TvFocusNodeSpec nodeById(String id) {
    return nodes.firstWhere((n) => n.id == id);
  }

  TvFocusTraversal? traversalFor(String id) {
    for (final edge in traversals) {
      if (edge.fromId == id) return edge;
    }
    return null;
  }

  /// True when every traversal endpoint and focus id resolves to a known node.
  bool get isConsistent {
    final ids = nodes.map((n) => n.id).toSet();
    if (!ids.contains(firstFocusId)) return false;
    if (restoreFocusId != null && !ids.contains(restoreFocusId)) return false;
    if (backTargetId != null && !ids.contains(backTargetId)) return false;
    for (final edge in traversals) {
      if (!ids.contains(edge.fromId)) return false;
      for (final target in [edge.up, edge.down, edge.left, edge.right]) {
        if (target != null && !ids.contains(target)) return false;
      }
    }
    return true;
  }
}
