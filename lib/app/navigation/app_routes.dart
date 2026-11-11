import '../client_kind.dart';

/// Named routes shared by TV and Companion (Navigator 1.0 — CMP-002).
///
/// No go_router until explicitly approved. Feature screens register here as
/// they graduate from gallery/demo pages into the product shell.
abstract final class AppRoutes {
  static const String home = '/';
  static const String companionRemote = '/companion/remote';
  static const String companionLogin = '/companion/login';
  static const String tvLive = '/tv/live';
  static const String tvSearch = '/tv/search';
  static const String tvSettings = '/tv/settings';

  /// Routes valid for [kind] in the MVP shell.
  static List<String> forClient(ClientKind kind) {
    switch (kind) {
      case ClientKind.tv:
        return const <String>[home, tvLive, tvSearch, tvSettings];
      case ClientKind.companion:
        return const <String>[home, companionRemote, companionLogin];
    }
  }
}
