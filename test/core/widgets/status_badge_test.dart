import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/core/widgets/status_badge.dart';

void main() {
  Future<void> pump(
    WidgetTester tester,
    Widget child, {
    ThemeData? theme,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: theme ?? AppTheme.tvDark(),
        home: Scaffold(
          backgroundColor: AppColors.ink,
          body: Center(child: child),
        ),
      ),
    );
  }

  test('StatusBadgeSpec locks DoD kinds to semantic roles', () {
    expect(StatusBadgeSpec.live.role, SemanticColorRole.liveAlert);
    expect(StatusBadgeSpec.live.label, 'LIVE');
    expect(StatusBadgeSpec.activeSource.role, SemanticColorRole.primaryAction);
    expect(StatusBadgeSpec.activeSource.label, 'Active source');
    expect(
      StatusBadgeSpec.synced.role,
      SemanticColorRole.syncedConnected,
    );
    expect(StatusBadgeSpec.connected.label, 'Connected');
    expect(
      StatusBadgeSpec.weakNetwork.role,
      SemanticColorRole.weakNetwork,
    );
    expect(StatusBadgeSpec.weakNetwork.label, 'Weak network');
  });

  testWidgets('LIVE badge pairs Ember cue with icon and LIVE text', (
    tester,
  ) async {
    await pump(tester, const StatusBadge.live());

    expect(find.text('LIVE'), findsOneWidget);
    expect(find.byIcon(Icons.fiber_manual_record), findsOneWidget);

    final icon = tester.widget<Icon>(find.byIcon(Icons.fiber_manual_record));
    expect(icon.color, AppColors.ember);
  });

  testWidgets('Active source badge uses Signal with label and icon', (
    tester,
  ) async {
    await pump(tester, const StatusBadge.activeSource());

    expect(find.text('Active source'), findsOneWidget);
    expect(find.byIcon(Icons.radio_button_checked), findsOneWidget);

    final icon = tester.widget<Icon>(find.byIcon(Icons.radio_button_checked));
    expect(icon.color, AppColors.signal);
  });

  testWidgets('Synced and Connected share Success role with distinct labels', (
    tester,
  ) async {
    await pump(
      tester,
      const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          StatusBadge.synced(),
          StatusBadge.connected(),
        ],
      ),
    );

    expect(find.text('Synced'), findsOneWidget);
    expect(find.text('Connected'), findsOneWidget);
    expect(find.byIcon(Icons.cloud_done_outlined), findsOneWidget);
    expect(find.byIcon(Icons.link), findsOneWidget);

    final synced = tester.widget<Icon>(find.byIcon(Icons.cloud_done_outlined));
    expect(synced.color, AppColors.success);
  });

  testWidgets('Weak network badge uses Warning with icon and label', (
    tester,
  ) async {
    await pump(tester, const StatusBadge.weakNetwork());

    expect(find.text('Weak network'), findsOneWidget);
    expect(find.byIcon(Icons.wifi_1_bar), findsOneWidget);

    final icon = tester.widget<Icon>(find.byIcon(Icons.wifi_1_bar));
    expect(icon.color, AppColors.warning);
  });

  testWidgets('Companion LIVE resolves companionLive accent', (tester) async {
    await pump(
      tester,
      const StatusBadge.live(),
      theme: AppTheme.companionLight(),
    );

    final icon = tester.widget<Icon>(find.byIcon(Icons.fiber_manual_record));
    expect(icon.color, AppColors.companionLive);
    expect(find.text('LIVE'), findsOneWidget);
  });
}
