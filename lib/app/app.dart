import 'package:flutter/material.dart';

import '../core/accessibility/companion_accessibility.dart';
import '../core/images/image_pipeline_route_observer.dart';
import '../core/theme/theme.dart';
import '../features/player/presentation/playback_session_lifecycle_binder.dart';
import 'client_kind.dart';
import 'di/app_dependencies.dart';
import 'navigation/app_navigator.dart';
import 'navigation/app_routes.dart';

/// Root application widget. [clientKind] selects TV vs Companion (ADR-001).
class MiIptvApp extends StatelessWidget {
  const MiIptvApp({
    super.key,
    this.clientKind = ClientKind.tv,
    this.initialRoute,
  });

  final ClientKind clientKind;

  /// Override for widget tests that skip the TV splash gate.
  final String? initialRoute;

  bool get _isCompanion => clientKind == ClientKind.companion;

  String get _defaultInitialRoute =>
      _isCompanion ? AppRoutes.home : AppRoutes.tvSplash;

  @override
  Widget build(BuildContext context) {
    final observers = <NavigatorObserver>[
      if (AppDependencies.isMounted)
        ImagePipelineRouteObserver(AppDependencies.instance.imagePipeline),
    ];
    return MaterialApp(
      title: _isCompanion ? 'Mi IPTV Companion' : 'Mi IPTV',
      debugShowCheckedModeBanner: false,
      theme: _isCompanion ? AppTheme.companionLight() : AppTheme.tvDark(),
      builder: (context, child) {
        Widget built = child ?? const SizedBox.shrink();
        if (_isCompanion) {
          built = CompanionAccessibleScope(child: built);
        } else if (AppDependencies.isMounted) {
          // TV-052: forward app background/foreground to session coordinator.
          built = PlaybackSessionLifecycleBinder(
            coordinator: AppDependencies.instance.playbackSession,
            child: built,
          );
        }
        return built;
      },
      // TV-020: splash gate inspects JWT then routes Home / Onboarding.
      initialRoute: initialRoute ?? _defaultInitialRoute,
      navigatorObservers: observers,
      onGenerateRoute: (settings) => AppNavigator.onGenerateRoute(
        settings,
        clientKind: clientKind,
      ),
    );
  }
}
