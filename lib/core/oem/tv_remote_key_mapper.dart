import 'package:flutter/services.dart';

import 'oem_quirk.dart';
import 'tv_remote_action.dart';

/// Maps physical / logical remote keys to [TvRemoteAction] (TV-011).
///
/// Always recognizes standard CH+/CH−. OEM quirks may add Page / media-track
/// aliases used by some Sony / TCL / Hisense skins.
final class TvRemoteKeyMapper {
  const TvRemoteKeyMapper({
    this.quirks = const <OemQuirk>{},
  });

  final Set<OemQuirk> quirks;

  bool get _pageKeysAsChannel => quirks.contains(OemQuirk.pageKeysAsChannel);

  /// Returns the remote action for [key], or null if unmapped.
  TvRemoteAction? actionFor(LogicalKeyboardKey key) {
    if (key == LogicalKeyboardKey.channelUp) {
      return TvRemoteAction.channelUp;
    }
    if (key == LogicalKeyboardKey.channelDown) {
      return TvRemoteAction.channelDown;
    }
    if (_pageKeysAsChannel) {
      if (key == LogicalKeyboardKey.pageUp ||
          key == LogicalKeyboardKey.mediaTrackNext) {
        return TvRemoteAction.channelUp;
      }
      if (key == LogicalKeyboardKey.pageDown ||
          key == LogicalKeyboardKey.mediaTrackPrevious) {
        return TvRemoteAction.channelDown;
      }
    }
    return null;
  }
}
