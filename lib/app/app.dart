import 'package:flutter/material.dart';

import '../core/accessibility/companion_accessibility.dart';
import '../core/theme/theme.dart';
import 'client_kind.dart';
import 'navigation/app_navigator.dart';
import 'navigation/app_routes.dart';

/// Root application widget. [clientKind] selects TV vs Companion (ADR-001).
class MiIptvApp extends StatelessWidget {
  const MiIptvApp({super.key, this.clientKind = ClientKind.tv});

  final ClientKind clientKind;

  bool get _isCompanion => clientKind == ClientKind.companion;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _isCompanion ? 'Mi IPTV Companion' : 'Mi IPTV',
      debugShowCheckedModeBanner: false,
      theme: _isCompanion ? AppTheme.companionLight() : AppTheme.tvDark(),
      builder: _isCompanion
          ? (context, child) => CompanionAccessibleScope(
                child: child ?? const SizedBox.shrink(),
              )
          : null,
      initialRoute: AppRoutes.home,
      onGenerateRoute: (settings) => AppNavigator.onGenerateRoute(
        settings,
        clientKind: clientKind,
      ),
    );
  }
}
