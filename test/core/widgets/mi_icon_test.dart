import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/core/widgets/mi_icon.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget child) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.tvDark(),
        home: Scaffold(
          backgroundColor: AppColors.ink,
          body: Center(child: child),
        ),
      ),
    );
  }

  testWidgets('ambiguous LIVE role always shows text label', (tester) async {
    await pump(tester, const MiIcon(role: IconRole.live));

    expect(find.text('LIVE'), findsOneWidget);
    expect(find.byIcon(Icons.fiber_manual_record), findsOneWidget);
  });

  testWidgets('labelRequired ignores showLabel false', (tester) async {
    await pump(
      tester,
      const MiIcon(role: IconRole.weakNetwork, showLabel: false),
    );

    expect(find.text('Weak network'), findsOneWidget);
  });

  testWidgets('clear play role stays icon-only by default', (tester) async {
    await pump(tester, const MiIcon(role: IconRole.play));

    expect(find.byIcon(Icons.play_arrow), findsOneWidget);
    expect(find.text('Play'), findsNothing);
  });

  testWidgets('showLabel forces text on clear metaphors', (tester) async {
    await pump(
      tester,
      const MiIcon(role: IconRole.search, showLabel: true),
    );

    expect(find.text('Search'), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
  });
}
