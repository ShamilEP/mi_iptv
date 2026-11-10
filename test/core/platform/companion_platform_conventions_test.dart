import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/platform/companion_platform.dart';
import 'package:mi_iptv/core/platform/companion_platform_conventions.dart';

void main() {
  test('DSN-054 resolves iOS vs Android hosts', () {
    expect(
      CompanionPlatformResolver.resolve(TargetPlatform.iOS),
      CompanionPlatform.ios,
    );
    expect(
      CompanionPlatformResolver.resolve(TargetPlatform.android),
      CompanionPlatform.android,
    );
    expect(
      CompanionPlatformResolver.resolve(TargetPlatform.windows),
      CompanionPlatform.android,
    );
  });

  test('locks navigation, safe area, keyboard, and haptic copy per platform', () {
    final android = CompanionPlatformConventions.android;
    final ios = CompanionPlatformConventions.ios;

    expect(android.usesSystemKeyboard, isTrue);
    expect(ios.usesSystemKeyboard, isTrue);
    expect(android.enforceSafeArea, isTrue);
    expect(ios.enforceSafeArea, isTrue);

    expect(android.backAffordanceLabel, 'System back');
    expect(ios.backAffordanceLabel, 'Back');
    expect(android.navigationTitle, 'Navigation');
    expect(ios.safeAreaTitle, 'Safe areas');
    expect(android.keyboardTitle, 'System keyboard');
    expect(ios.hapticsTitle, 'Haptics');
    expect(android.navigationBody, contains('predictive back'));
    expect(ios.navigationBody, contains('edge-swipe'));
    expect(android.safeAreaBody, contains('SafeArea'));
    expect(ios.keyboardBody, contains('system keyboard'));
  });

  test('of() returns the requested platform conventions', () {
    expect(
      CompanionPlatformConventions.of(CompanionPlatform.ios).platform,
      CompanionPlatform.ios,
    );
    expect(
      CompanionPlatformConventions.of(CompanionPlatform.android).platform,
      CompanionPlatform.android,
    );
  });
}
