import 'package:flutter/foundation.dart';

/// Companion host OS for design conventions (DSN-054).
enum CompanionPlatform {
  /// Material / Android system patterns.
  android,

  /// Cupertino / iOS system patterns.
  ios,
}

/// Resolves [CompanionPlatform] from a Flutter [TargetPlatform].
abstract final class CompanionPlatformResolver {
  /// Maps iOS to [CompanionPlatform.ios]; every other target to Android.
  ///
  /// Companion MVP ships Android and iOS only. Desktop/web hosts fall back to
  /// Android conventions so design shells stay deterministic in tests.
  static CompanionPlatform resolve([TargetPlatform? platform]) {
    final host = platform ?? defaultTargetPlatform;
    return host == TargetPlatform.iOS
        ? CompanionPlatform.ios
        : CompanionPlatform.android;
  }
}
