import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/features/devices/presentation/pairing_code_models.dart';
import 'package:mi_iptv/features/devices/presentation/tv/tv_pairing_code_page.dart';

void main() {
  Future<void> pump(WidgetTester tester, {TvPairingCodePage? page}) async {
    await tester.binding.setSurfaceSize(const Size(1920, 1080));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.tvDark(),
        home: page ?? const TvPairingCodePage(),
      ),
    );
    await tester.pump();
  }

  testWidgets('DSN-071 TV shows spaced pairing code and waiting cue', (
    tester,
  ) async {
    await pump(tester);

    expect(find.text(PairingCodeCopy.tvTitle), findsOneWidget);
    expect(
      find.byKey(const ValueKey<String>('pairing-tv-code')),
      findsOneWidget,
    );
    expect(find.text('482 913'), findsOneWidget);
    expect(
      find.byKey(const ValueKey<String>('pairing-tv-waiting')),
      findsOneWidget,
    );
    expect(find.text(PairingCodeCopy.tvWaiting), findsOneWidget);
  });

  testWidgets('DSN-071 TV refresh cycles demo codes', (tester) async {
    String? refreshed;
    await pump(
      tester,
      page: TvPairingCodePage(onRefreshCode: (code) => refreshed = code),
    );

    await tester.tap(find.byKey(const ValueKey<String>('pairing-tv-refresh')));
    await tester.pump();

    expect(refreshed, '719304');
    expect(find.text('719 304'), findsOneWidget);
  });

  testWidgets('DSN-071 TV linked screen shows success', (tester) async {
    await pump(
      tester,
      page: const TvPairingCodePage(initialScreen: PairingCodeScreen.linked),
    );

    expect(find.text(PairingCodeCopy.tvLinkedTitle), findsOneWidget);
    expect(
      find.byKey(const ValueKey<String>('pairing-tv-linked-icon')),
      findsOneWidget,
    );
  });
}
