/// Where TV continues after splash (TV-020 / Frontend §2.3).
enum StartupDestination {
  /// Stored session JWT present — enter the main shell.
  home,

  /// No usable session — onboarding / auth.
  onboarding,
}
