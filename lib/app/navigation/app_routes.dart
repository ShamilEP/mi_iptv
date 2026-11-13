import '../client_kind.dart';

/// Named routes shared by TV and Companion (Navigator 1.0 — CMP-002 / TV-002).
///
/// No go_router until explicitly approved. Feature screens register here as
/// they graduate from gallery/demo pages into the product shell.
abstract final class AppRoutes {
  static const String home = '/';
  /// TV splash + startup routing gate (TV-020).
  static const String tvSplash = '/tv/splash';
  /// TV onboarding / auth when no stored session JWT (TV-020).
  static const String tvOnboarding = '/tv/onboarding';
  static const String companionRemote = '/companion/remote';
  static const String companionLogin = '/companion/login';
  /// Companion UI language + locale formats (CMP-008).
  static const String companionLanguage = '/companion/language';
  static const String tvLive = '/tv/live';
  static const String tvSearch = '/tv/search';
  static const String tvFavorites = '/tv/favorites';
  static const String tvContentDetail = '/tv/content-detail';
  static const String tvSettings = '/tv/settings';
  /// VOD playback shell (catalog item → player). Design scaffold until Media3.
  static const String tvVodPlayer = '/tv/vod';

  /// Routes valid for [kind] in the MVP shell.
  static List<String> forClient(ClientKind kind) {
    switch (kind) {
      case ClientKind.tv:
        return const <String>[
          home,
          tvSplash,
          tvOnboarding,
          tvLive,
          tvSearch,
          tvFavorites,
          tvContentDetail,
          tvSettings,
          tvVodPlayer,
        ];
      case ClientKind.companion:
        return const <String>[
          home,
          companionRemote,
          companionLogin,
          companionLanguage,
        ];
    }
  }
}
