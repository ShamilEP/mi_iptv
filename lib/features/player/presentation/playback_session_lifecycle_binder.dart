import 'package:flutter/widgets.dart';

import '../domain/services/playback_session_coordinator.dart';

/// Forwards Flutter app lifecycle to [PlaybackSessionCoordinator] (TV-052).
///
/// Mount once under the TV app root. Does not render UI.
final class PlaybackSessionLifecycleBinder extends StatefulWidget {
  const PlaybackSessionLifecycleBinder({
    super.key,
    required this.coordinator,
    required this.child,
  });

  final PlaybackSessionCoordinator coordinator;
  final Widget child;

  @override
  State<PlaybackSessionLifecycleBinder> createState() =>
      _PlaybackSessionLifecycleBinderState();
}

class _PlaybackSessionLifecycleBinderState
    extends State<PlaybackSessionLifecycleBinder> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
      case AppLifecycleState.detached:
        widget.coordinator.onAppBackgrounded();
      case AppLifecycleState.resumed:
        widget.coordinator.onAppForegrounded();
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
