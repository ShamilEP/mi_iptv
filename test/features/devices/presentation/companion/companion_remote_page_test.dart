import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/core/widgets/mi_text_field.dart';
import 'package:mi_iptv/features/devices/presentation/companion/companion_remote_copy.dart';
import 'package:mi_iptv/features/devices/presentation/companion/companion_remote_page.dart';

void main() {
  Future<void> pump(WidgetTester tester, {CompanionRemotePage? page}) async {
    await tester.binding.setSurfaceSize(const Size(390, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.companionLight(),
        home: page ?? CompanionRemotePage(onFeedback: () async {}),
      ),
    );
    await tester.pump();
  }

  testWidgets('DSN-051 shows D-pad, volume, transport, and keyboard', (
    tester,
  ) async {
    await pump(tester);

    expect(find.text(CompanionRemoteCopy.title), findsOneWidget);
    expect(find.text(CompanionRemoteCopy.demoTvName), findsOneWidget);
    expect(find.text('Connected'), findsOneWidget);
    for (final command in CompanionRemoteCommand.values) {
      expect(find.text(CompanionRemoteCopy.labelFor(command)), findsOneWidget);
    }
    expect(find.text(CompanionRemoteCopy.keyboardLabel), findsWidgets);
    expect(find.text(CompanionRemoteCopy.sendLabel), findsOneWidget);
  });

  testWidgets('press gives haptic and names the control', (tester) async {
    var haptics = 0;
    CompanionRemoteCommand? command;
    await pump(
      tester,
      page: CompanionRemotePage(
        onFeedback: () async {
          haptics++;
        },
        onCommand: (value) => command = value,
      ),
    );

    await tester.tap(find.byKey(const ValueKey('remote-key-Up')));
    await tester.pump();

    expect(command, CompanionRemoteCommand.up);
    expect(haptics, 1);
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('remote-feedback')),
        matching: find.text('Up'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('OK press fills with the companion primary color', (
    tester,
  ) async {
    await pump(tester);

    final gesture = await tester.startGesture(
      tester.getCenter(find.byKey(const ValueKey('remote-key-OK'))),
    );
    await tester.pump(AppMotion.fast);

    final container = tester.widget<AnimatedContainer>(
      find.byKey(const ValueKey('remote-key-OK')),
    );
    final decoration = container.decoration! as BoxDecoration;
    expect(decoration.color, AppColors.companionPrimary);

    await gesture.up();
    await tester.pump();
  });

  testWidgets('keyboard send confirms text and empty send does not', (
    tester,
  ) async {
    String? sent;
    await pump(
      tester,
      page: CompanionRemotePage(
        onFeedback: () async {},
        onKeyboardSubmit: (value) => sent = value,
      ),
    );

    await tester.tap(find.text(CompanionRemoteCopy.sendLabel));
    await tester.pump();
    expect(sent, isNull);
    expect(find.text(CompanionRemoteCopy.emptyKeyboardMessage), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(MiTextField, CompanionRemoteCopy.keyboardLabel),
      'news',
    );
    await tester.tap(find.text(CompanionRemoteCopy.sendLabel));
    await tester.pump();

    expect(sent, 'news');
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('remote-feedback')),
        matching: find.text('news'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('offline target keeps an Offline label', (tester) async {
    await pump(
      tester,
      page: CompanionRemotePage(connected: false, onFeedback: () async {}),
    );

    expect(find.text('Offline'), findsOneWidget);
    expect(find.text('Connected'), findsNothing);
  });
}
