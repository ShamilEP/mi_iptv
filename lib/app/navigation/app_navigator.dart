import 'package:flutter/material.dart';

import '../../features/auth/presentation/companion/companion_login_pairing_page.dart';
import '../../features/catalog/presentation/companion/companion_explore_page.dart';
import '../../features/devices/presentation/companion/companion_remote_page.dart';
import '../../features/home/presentation/tv/tv_home_page.dart';
import '../../features/live_tv/presentation/tv/tv_live_tv_page.dart';
import '../../features/search/presentation/tv/tv_search_page.dart';
import '../../features/settings/presentation/tv/tv_settings_page.dart';
import '../client_kind.dart';
import 'app_routes.dart';

/// Builds [MaterialPageRoute]s for [AppRoutes] (CMP-002).
abstract final class AppNavigator {
  static Route<dynamic> onGenerateRoute(
    RouteSettings settings, {
    required ClientKind clientKind,
  }) {
    final name = settings.name ?? AppRoutes.home;
    final allowed = AppRoutes.forClient(clientKind);
    if (!allowed.contains(name)) {
      return _unknown(settings, 'Route $name is not available for $clientKind');
    }

    switch (name) {
      case AppRoutes.home:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => clientKind == ClientKind.companion
              ? const CompanionExplorePage()
              : const TvHomePage(),
        );
      case AppRoutes.companionRemote:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const CompanionRemotePage(),
        );
      case AppRoutes.companionLogin:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const CompanionLoginPairingPage(),
        );
      case AppRoutes.tvLive:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const TvLiveTvPage(),
        );
      case AppRoutes.tvSearch:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const TvSearchPage(),
        );
      case AppRoutes.tvSettings:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const TvSettingsPage(),
        );
      default:
        return _unknown(settings, 'Unknown route $name');
    }
  }

  static Route<dynamic> _unknown(RouteSettings settings, String message) {
    return MaterialPageRoute<void>(
      settings: settings,
      builder: (_) => Scaffold(
        body: Center(child: Text(message)),
      ),
    );
  }
}
