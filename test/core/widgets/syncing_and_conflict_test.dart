import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/core/widgets/sync_conflict_banner.dart';
import 'package:mi_iptv/core/widgets/syncing_pattern.dart';

void main() {
  testWidgets('SyncingPattern shows Syncing label and progress', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.companionLight(),
        home: const Scaffold(body: Center(child: SyncingPattern())),
      ),
    );

    expect(find.text('Syncing'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('SyncConflictBanner pairs warning with Resolve', (tester) async {
    var resolved = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.companionLight(),
        home: Scaffold(
          body: SyncConflictBanner(
            message: 'Positions differ',
            onResolve: () => resolved = true,
          ),
        ),
      ),
    );

    expect(find.text('Sync Conflict'), findsOneWidget);
    expect(find.byIcon(Icons.warning_amber_outlined), findsOneWidget);
    await tester.tap(find.text('Resolve'));
    await tester.pump();
    expect(resolved, isTrue);
  });
}
