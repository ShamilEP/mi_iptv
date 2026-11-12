/// Deploy / backend environment (TV-002). Orthogonal to [ClientKind].
///
/// Selected at bootstrap via `--dart-define=APP_ENV=dev|qa|prod` and mirrored
/// by Android product flavors on the `env` dimension (`dev` / `qa` / `prod`).
enum AppEnvironment {
  dev,
  qa,
  prod;

  /// Parses [raw] (case-insensitive). Unknown or empty → [AppEnvironment.dev]
  /// so local `flutter run` stays on the non-production graph by default.
  static AppEnvironment parse(String? raw) {
    switch (raw?.trim().toLowerCase()) {
      case 'qa':
        return AppEnvironment.qa;
      case 'prod':
      case 'production':
        return AppEnvironment.prod;
      case 'dev':
      case 'development':
      case null:
      case '':
        return AppEnvironment.dev;
      default:
        return AppEnvironment.dev;
    }
  }

  /// Compile-time default from `--dart-define=APP_ENV=...`.
  static AppEnvironment fromDartDefine() =>
      parse(const String.fromEnvironment('APP_ENV', defaultValue: 'dev'));

  /// Suffix used in Android `applicationId` for non-prod installs.
  String get applicationIdSuffix => switch (this) {
        AppEnvironment.dev => '.dev',
        AppEnvironment.qa => '.qa',
        AppEnvironment.prod => '',
      };
}
