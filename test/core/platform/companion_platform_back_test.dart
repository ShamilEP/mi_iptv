import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/platform/companion_platform.dart';
import 'package:mi_iptv/core/platform/companion_platform_back.dart';
import 'package:mi_iptv/core/theme/theme.dart';

void main() {
  Future<void> pump(
    WidgetTester tester, {
    required CompanionPlatform platform,
    required VoidCallback onBack,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.companionLight(),
        home: Scaffold(
          body: CompanionPlatformBackAffordance(
            platform: platform,
            onBack: onBack,
          ),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('Android back affordance stays empty for system Back', (
    tester,
  ) async {
    var taps = 0;
    await pump(
      tester,
      platform: CompanionPlatform.android,
      onBack: () => taps++,
    );

    expect(find.byKey(const ValueKey<String>('companion-back-android')), findsOneWidget);
    expect(find.text('Back'), findsNothing);
    expect(find.text('System back'), findsNothing);
    expect(taps, 0);
  });

  testWidgets('iOS back affordance shows chevron and fires onBack', (
    tester,
  ) async {
    var taps = 0;
    await pump(
      tester,
      platform: CompanionPlatform.ios,
      onBack: () => taps++,
    );

    expect(find.byKey(const ValueKey<String>('companion-back-ios')), findsOneWidget);
    expect(find.text('Back'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey<String>('companion-back-ios')));
    await tester.pump();
    expect(taps, 1);
  });
}
