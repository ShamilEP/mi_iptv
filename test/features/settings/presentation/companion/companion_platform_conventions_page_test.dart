import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/platform/companion_platform.dart';
import 'package:mi_iptv/core/platform/companion_platform_conventions.dart';
import 'package:mi_iptv/core/platform/companion_platform_shell.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/core/widgets/mi_text_field.dart';
import 'package:mi_iptv/features/settings/presentation/companion/companion_platform_conventions_page.dart';

void main() {
  Future<void> pump(
    WidgetTester tester, {
    CompanionPlatformConventionsPage? page,
  }) async {
    await tester.binding.setSurfaceSize(const Size(390, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.companionLight(),
        home: page ?? const CompanionPlatformConventionsPage(),
      ),
    );
    await tester.pump();
  }

  testWidgets('DSN-054 shows Android conventions by default', (tester) async {
    await pump(tester);

    expect(find.byType(CompanionPlatformShell), findsOneWidget);
    expect(find.text(CompanionPlatformConventionsPage.title), findsOneWidget);
    expect(
      find.text(CompanionPlatformConventions.android.navigationBody),
      findsOneWidget,
    );
    expect(
      find.text(CompanionPlatformConventions.android.backAffordanceLabel),
      findsOneWidget,
    );
    expect(find.byType(MiTextField), findsOneWidget);
    expect(find.text('Try haptic'), findsOneWidget);
  });

  testWidgets('switching to iOS updates navigation and shows back chevron', (
    tester,
  ) async {
    await pump(tester);

    expect(find.byKey(const ValueKey<String>('companion-back-android')), findsOneWidget);
    expect(find.byKey(const ValueKey<String>('companion-back-ios')), findsNothing);

    await tester.tap(find.text('iOS'));
    await tester.pump();

    expect(
      find.text(CompanionPlatformConventions.ios.navigationBody),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey<String>('companion-back-ios')), findsOneWidget);
    expect(
      find.text(CompanionPlatformConventions.ios.hapticsBody),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const ValueKey<String>('companion-back-ios')));
    await tester.pump();
    expect(find.byKey(const ValueKey<String>('platform-back-pressed')), findsOneWidget);
  });

  testWidgets('haptic action uses the injected callback', (tester) async {
    var taps = 0;
    await pump(
      tester,
      page: CompanionPlatformConventionsPage(
        initialPlatform: CompanionPlatform.ios,
        onHaptic: () async {
          taps++;
        },
      ),
    );

    await tester.tap(find.text('Try haptic'));
    await tester.pump();

    expect(taps, 1);
    expect(find.text('Haptics'), findsWidgets);
  });
}
