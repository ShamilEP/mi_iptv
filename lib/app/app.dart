import 'package:flutter/material.dart';

import '../core/accessibility/companion_accessibility.dart';
import '../core/theme/theme.dart';
import '../features/home/presentation/tv/tv_home_page.dart';

/// Root application widget. Client flavor (tv vs companion) can branch later.
class MiIptvApp extends StatelessWidget {
  const MiIptvApp({super.key, this.useCompanionTheme = false});

  final bool useCompanionTheme;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi IPTV',
      debugShowCheckedModeBanner: false,
      theme: useCompanionTheme ? AppTheme.companionLight() : AppTheme.tvDark(),
      builder: useCompanionTheme
          ? (context, child) => CompanionAccessibleScope(
                child: child ?? const SizedBox.shrink(),
              )
          : null,
      home: const TvHomePage(),
    );
  }
}
