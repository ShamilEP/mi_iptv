import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/core/widgets/stream_failure_recovery_overlay.dart';

void main() {
  testWidgets('DSN-039 shows channel context and recovery actions', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1280, 720));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    var retried = false;
    var switched = false;
    var backed = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.tvDark(),
        home: Scaffold(
          backgroundColor: AppColors.ink,
          body: StreamFailureRecoveryOverlay(
            channelNumber: '12',
            channelTitle: 'Signal News',
            sourceLabel: 'Home Xtream',
            onRetry: () => retried = true,
            onSwitchSource: () => switched = true,
            onBackToChannels: () => backed = true,
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Error'), findsOneWidget);
    expect(
      find.text(StreamFailureRecoveryOverlay.defaultMessage),
      findsOneWidget,
    );
    expect(find.text('12'), findsOneWidget);
    expect(find.text('Signal News'), findsOneWidget);
    expect(find.text('Home Xtream'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
    expect(find.text('Switch source'), findsOneWidget);
    expect(find.text('Back to channels'), findsOneWidget);
    expect(find.byIcon(Icons.error_outline), findsOneWidget);
    expect(find.byIcon(Icons.live_tv_outlined), findsOneWidget);

    await tester.tap(find.text('Retry'));
    await tester.tap(find.text('Switch source'));
    await tester.tap(find.text('Back to channels'));
    await tester.pump();

    expect(retried, isTrue);
    expect(switched, isTrue);
    expect(backed, isTrue);
  });
}
