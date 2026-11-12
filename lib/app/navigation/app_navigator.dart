import 'package:flutter/material.dart';

import '../../features/auth/presentation/companion/companion_login_pairing_page.dart';
import '../../features/catalog/presentation/companion/companion_explore_page.dart';
import '../../features/catalog/presentation/tv/tv_content_detail_page.dart';
import '../../features/devices/presentation/companion/companion_remote_page.dart';
import '../../features/favorites/presentation/tv/tv_favorites_page.dart';
import '../../features/home/presentation/tv/tv_home_connectivity_binder.dart';
import '../../features/live_tv/presentation/tv/tv_live_tv_page.dart';
import '../../features/player/presentation/tv/tv_vod_player_page.dart';
import '../../features/search/presentation/tv/tv_search_page.dart';
import '../../features/settings/presentation/tv/tv_settings_page.dart';
import '../client_kind.dart';
import '../di/app_dependencies.dart';
import 'app_routes.dart';

/// Builds [MaterialPageRoute]s for [AppRoutes] (CMP-002 / TV-002).
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
              : const TvHomeConnectivityBinder(),
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
      case AppRoutes.tvFavorites:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const TvFavoritesPage(),
        );
      case AppRoutes.tvContentDetail:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const TvContentDetailPage(),
        );
      case AppRoutes.tvSettings:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const TvSettingsPage(),
        );
      case AppRoutes.tvVodPlayer:
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) {
            // TV-062: wire Media3 when the composition root is mounted.
            final player = AppDependencies.isMounted
                ? AppDependencies.instance.mediaPlayer
                : null;
            return TvVodPlayerPage(mediaPlayer: player);
          },
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
