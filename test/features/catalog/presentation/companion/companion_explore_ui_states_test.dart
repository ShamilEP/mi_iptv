import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/core/widgets/loading_pattern.dart';
import 'package:mi_iptv/core/widgets/status_pattern_copy.dart';
import 'package:mi_iptv/core/widgets/sync_conflict_banner.dart';
import 'package:mi_iptv/core/widgets/syncing_pattern.dart';
import 'package:mi_iptv/features/catalog/presentation/companion/companion_explore_copy.dart';
import 'package:mi_iptv/features/catalog/presentation/companion/companion_explore_page.dart';

void main() {
  Future<void> pump(
    WidgetTester tester, {
    required CompanionExploreSurfaceState state,
    VoidCallback? onRetry,
    VoidCallback? onResolve,
  }) async {
    await tester.binding.setSurfaceSize(const Size(390, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.companionLight(),
        home: CompanionExplorePage(
          surfaceState: state,
          onRetry: onRetry,
          onResolveConflict: onResolve,
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('CMP-045 loading shows Loading cue', (tester) async {
    await pump(tester, state: CompanionExploreSurfaceState.loading);
    expect(find.byType(LoadingPattern), findsOneWidget);
    expect(find.text('Loading'), findsOneWidget);
    expect(find.text(CompanionExploreCopy.featuredTitle), findsNothing);
  });

  testWidgets('CMP-045 empty shows explore empty copy', (tester) async {
    var retried = false;
    await pump(
      tester,
      state: CompanionExploreSurfaceState.empty,
      onRetry: () => retried = true,
    );
    expect(find.text('Empty'), findsOneWidget);
    expect(find.text(StatusPatternCopy.exploreEmpty.title), findsOneWidget);
    await tester.tap(find.text('Refresh'));
    await tester.pump();
    expect(retried, isTrue);
  });

  testWidgets('CMP-045 error and offline keep actions', (tester) async {
    var retried = 0;
    await pump(
      tester,
      state: CompanionExploreSurfaceState.error,
      onRetry: () => retried++,
    );
    expect(find.text('Error'), findsOneWidget);
    await tester.tap(find.text('Retry'));
    await tester.pump();

    await pump(
      tester,
      state: CompanionExploreSurfaceState.offline,
      onRetry: () => retried++,
    );
    expect(find.text('Offline'), findsOneWidget);
    await tester.tap(find.text('Try again'));
    await tester.pump();
    expect(retried, 2);
  });

  testWidgets('CMP-045 syncing and sync conflict cues', (tester) async {
    var resolved = false;
    await pump(tester, state: CompanionExploreSurfaceState.syncing);
    expect(find.byType(SyncingPattern), findsOneWidget);
    expect(find.text('Syncing'), findsOneWidget);

    await pump(
      tester,
      state: CompanionExploreSurfaceState.syncConflict,
      onResolve: () => resolved = true,
    );
    expect(find.byType(SyncConflictBanner), findsOneWidget);
    expect(find.text('Sync Conflict'), findsOneWidget);
    expect(find.text(CompanionExploreCopy.syncConflictMessage), findsOneWidget);
    await tester.tap(find.text('Resolve'));
    await tester.pump();
    expect(resolved, isTrue);
  });
}
