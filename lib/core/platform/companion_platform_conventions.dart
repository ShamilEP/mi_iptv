import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'companion_platform.dart';

/// Locked companion navigation / safe-area / keyboard / haptic rules (DSN-054).
@immutable
class CompanionPlatformConventions {
  const CompanionPlatformConventions._({
    required this.platform,
    required this.navigationTitle,
    required this.navigationBody,
    required this.safeAreaTitle,
    required this.safeAreaBody,
    required this.keyboardTitle,
    required this.keyboardBody,
    required this.hapticsTitle,
    required this.hapticsBody,
    required this.backAffordanceLabel,
  });

  final CompanionPlatform platform;

  final String navigationTitle;
  final String navigationBody;
  final String safeAreaTitle;
  final String safeAreaBody;
  final String keyboardTitle;
  final String keyboardBody;
  final String hapticsTitle;
  final String hapticsBody;

  /// Visible back cue for demos (iOS chevron copy; Android system-back copy).
  final String backAffordanceLabel;

  /// Conventions for the current host (or an explicit [platform] override).
  factory CompanionPlatformConventions.of([CompanionPlatform? platform]) {
    final resolved =
        platform ?? CompanionPlatformResolver.resolve(defaultTargetPlatform);
    switch (resolved) {
      case CompanionPlatform.android:
        return android;
      case CompanionPlatform.ios:
        return ios;
    }
  }

  static const CompanionPlatformConventions android =
      CompanionPlatformConventions._(
        platform: CompanionPlatform.android,
        navigationTitle: 'Navigation',
        navigationBody:
            'Use Android system Back and predictive back. Do not invent a '
            'leading chevron when the system gesture already handles leave.',
        safeAreaTitle: 'Safe areas',
        safeAreaBody:
            'Wrap scaffolds in SafeArea so content clears the status bar and '
            'gesture or 3-button navigation inset.',
        keyboardTitle: 'System keyboard',
        keyboardBody:
            'Text fields use the Android system IME. Companion never mounts the '
            'TV on-screen keyboard for typing.',
        hapticsTitle: 'Haptics',
        hapticsBody:
            'Selection uses a light impact. Remote keys and primary presses use '
            'a heavier impact.',
        backAffordanceLabel: 'System back',
      );

  static const CompanionPlatformConventions ios = CompanionPlatformConventions._(
    platform: CompanionPlatform.ios,
    navigationTitle: 'Navigation',
    navigationBody:
        'Honor the iOS edge-swipe back gesture and a leading back chevron on '
        'pushed screens.',
    safeAreaTitle: 'Safe areas',
    safeAreaBody:
        'Wrap scaffolds in SafeArea so content clears the notch or Dynamic '
        'Island and the home indicator.',
    keyboardTitle: 'System keyboard',
    keyboardBody:
        'Text fields use the iOS system keyboard. Companion never mounts the '
        'TV on-screen keyboard for typing.',
    hapticsTitle: 'Haptics',
    hapticsBody:
        'Selection uses selection click. Remote keys and primary presses use a '
        'light impact.',
    backAffordanceLabel: 'Back',
  );

  /// True for every companion host — text entry is always the OS IME.
  bool get usesSystemKeyboard => true;

  /// True for every companion host — notches and bars use Flutter SafeArea.
  bool get enforceSafeArea => true;

  /// Lighter haptic for pickers / selection changes.
  Future<void> selectionFeedback() {
    switch (platform) {
      case CompanionPlatform.android:
        return HapticFeedback.lightImpact();
      case CompanionPlatform.ios:
        return HapticFeedback.selectionClick();
    }
  }

  /// Stronger haptic for remote keys and primary actions.
  Future<void> impactFeedback() {
    switch (platform) {
      case CompanionPlatform.android:
        return HapticFeedback.mediumImpact();
      case CompanionPlatform.ios:
        return HapticFeedback.lightImpact();
    }
  }

  static const List<CompanionPlatformConventions> all =
      <CompanionPlatformConventions>[android, ios];
}
