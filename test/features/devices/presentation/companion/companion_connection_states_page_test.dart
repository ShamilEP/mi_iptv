import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/features/devices/presentation/companion/companion_connection_notice.dart';
import 'package:mi_iptv/features/devices/presentation/companion/companion_connection_state.dart';
import 'package:mi_iptv/features/devices/presentation/companion/companion_connection_states_page.dart';

void main() {
  Future<void> pump(
    WidgetTester tester, {
    CompanionConnectionStatesPage? page,
  }) async {
    await tester.binding.setSurfaceSize(const Size(390, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.companionLight(),
        home: page ?? const CompanionConnectionStatesPage(),
      ),
    );
    await tester.pump();
  }

  test('DSN-053 locks the five connection notice specs', () {
    expect(CompanionConnectionNoticeSpec.all, hasLength(5));
    expect(
      CompanionConnectionNoticeSpec.all.map((s) => s.state).toList(),
      <CompanionConnectionState>[
        CompanionConnectionState.connected,
        CompanionConnectionState.disconnected,
        CompanionConnectionState.pairingError,
        CompanionConnectionState.tvOffline,
        CompanionConnectionState.noNetwork,
      ],
    );
    expect(CompanionConnectionNoticeSpec.connected.title, 'Connected');
    expect(CompanionConnectionNoticeSpec.disconnected.title, 'Disconnected');
    expect(CompanionConnectionNoticeSpec.pairingError.title, 'Pairing error');
    expect(CompanionConnectionNoticeSpec.tvOffline.title, 'TV offline');
    expect(CompanionConnectionNoticeSpec.noNetwork.title, 'No network');
  });

  testWidgets('gallery shows every connection and notification state', (
    tester,
  ) async {
    await pump(tester);

    expect(find.text(CompanionConnectionStatesPage.title), findsOneWidget);
    for (final spec in CompanionConnectionNoticeSpec.all) {
      expect(find.text(spec.title), findsOneWidget);
      expect(find.text(spec.message), findsOneWidget);
    }
    expect(find.byType(CompanionConnectionNotice), findsNWidgets(5));
  });

  testWidgets('notice action reports its connection state', (tester) async {
    CompanionConnectionState? pressed;
    await pump(
      tester,
      page: CompanionConnectionStatesPage(
        onNoticeAction: (state) => pressed = state,
      ),
    );

    await tester.tap(find.text(CompanionConnectionNoticeSpec.pairingError.actionLabel));
    await tester.pump();

    expect(pressed, CompanionConnectionState.pairingError);
  });

  testWidgets('standalone notice pairs accent with icon and title', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.companionLight(),
        home: Scaffold(
          body: CompanionConnectionNotice.forState(
            CompanionConnectionState.noNetwork,
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('No network'), findsOneWidget);
    expect(
      find.text(CompanionConnectionNoticeSpec.noNetwork.message),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.wifi_off_outlined), findsOneWidget);
  });
}
