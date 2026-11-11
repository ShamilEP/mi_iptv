import 'package:flutter/material.dart';

import '../core/accessibility/companion_accessibility.dart';
import '../core/theme/theme.dart';
import '../features/catalog/presentation/companion/companion_explore_page.dart';
import '../features/home/presentation/tv/tv_home_page.dart';
import 'client_kind.dart';

/// Root application widget. [clientKind] selects TV vs Companion (ADR-001).
class MiIptvApp extends StatelessWidget {
  const MiIptvApp({super.key, this.clientKind = ClientKind.tv});

  final ClientKind clientKind;

  bool get _isCompanion => clientKind == ClientKind.companion;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi IPTV',
      debugShowCheckedModeBanner: false,
      theme: _isCompanion ? AppTheme.companionLight() : AppTheme.tvDark(),
      builder: _isCompanion
          ? (context, child) => CompanionAccessibleScope(
                child: child ?? const SizedBox.shrink(),
              )
          : null,
      home: _isCompanion
          ? const CompanionExplorePage()
          : const TvHomePage(),
    );
  }
}
