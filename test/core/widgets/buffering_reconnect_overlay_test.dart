import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/core/widgets/buffering_reconnect_overlay.dart';

void main() {
  testWidgets('TV-055 spinner shows Loading without jargon', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1280, 720));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.tvDark(),
        home: const Scaffold(
          backgroundColor: AppColors.ink,
          body: BufferingReconnectOverlay(
            label: BufferingReconnectOverlay.bufferingLabel,
          ),
        ),
      ),
    );

    expect(find.text('Loading…'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.textContaining('ERROR_CODE'), findsNothing);
  });

  testWidgets('TV-055 spinner shows Reconnecting copy', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.tvDark(),
        home: const Scaffold(
          body: BufferingReconnectOverlay(
            label: BufferingReconnectOverlay.reconnectingLabel,
          ),
        ),
      ),
    );

    expect(find.text('Reconnecting…'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
