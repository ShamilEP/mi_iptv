import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/core/widgets/status_pattern.dart';
import 'package:mi_iptv/core/widgets/status_pattern_copy.dart';
import 'package:mi_iptv/core/widgets/ui_state.dart';

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

  testWidgets('EmptyPattern.favorites locks DoD copy and action', (tester) async {
    var tapped = false;
    await pump(
      tester,
      EmptyPattern.favorites(onAction: () => tapped = true),
    );

    expect(find.text('No hay favoritos'), findsOneWidget);
    expect(find.text('Empty'), findsOneWidget);
    expect(find.text(StatusPatternCopy.favoritesEmpty.actionLabel), findsOneWidget);
    expect(find.byIcon(Icons.favorite_border), findsOneWidget);

    await tester.tap(find.text(StatusPatternCopy.favoritesEmpty.actionLabel));
    await tester.pumpAndSettle();
    expect(tapped, isTrue);
  });

  testWidgets('ErrorPattern shows error cue and retry', (tester) async {
    var retried = false;
    await pump(
      tester,
      ErrorPattern(onAction: () => retried = true),
    );

    expect(find.text('Error'), findsOneWidget);
    expect(find.text(StatusPatternCopy.genericError.title), findsOneWidget);
    expect(find.byIcon(Icons.error_outline), findsOneWidget);

    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(retried, isTrue);
  });

  testWidgets('OfflinePattern shows offline cue and try again', (tester) async {
    var tried = false;
    await pump(
      tester,
      OfflinePattern(onAction: () => tried = true),
    );

    expect(find.text('Offline'), findsOneWidget);
    expect(find.text(StatusPatternCopy.genericOffline.title), findsOneWidget);
    expect(find.byIcon(Icons.wifi_off_outlined), findsOneWidget);

    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(tried, isTrue);
  });

  test('StatusPatternCopy defaults cover empty error offline', () {
    expect(StatusPatternCopy.defaultsFor(UiState.empty).actionLabel, isNotEmpty);
    expect(StatusPatternCopy.defaultsFor(UiState.error).actionLabel, 'Retry');
    expect(StatusPatternCopy.defaultsFor(UiState.offline).actionLabel, 'Try again');
  });
}
