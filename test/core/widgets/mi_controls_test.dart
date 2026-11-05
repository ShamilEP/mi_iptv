import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/core/widgets/control_chrome.dart';
import 'package:mi_iptv/core/widgets/mi_button.dart';
import 'package:mi_iptv/core/widgets/mi_chip.dart';
import 'package:mi_iptv/core/widgets/mi_list_row.dart';
import 'package:mi_iptv/core/widgets/mi_text_field.dart';
import 'package:mi_iptv/core/widgets/mi_toggle.dart';
import 'package:mi_iptv/core/widgets/ui_state.dart';
import 'package:mi_iptv/core/widgets/ui_state_catalog.dart';

void main() {
  Future<void> pumpTheme(
    WidgetTester tester, {
    required ThemeData theme,
    required Widget child,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        home: Scaffold(body: Center(child: child)),
      ),
    );
  }

  group('ControlChrome DSN-013', () {
    testWidgets('resolves all 12 states on TV and Companion', (tester) async {
      for (final theme in <ThemeData>[
        AppTheme.tvDark(),
        AppTheme.companionLight(),
      ]) {
        for (final state in UiState.values) {
          await pumpTheme(
            tester,
            theme: theme,
            child: Builder(
              builder: (context) {
                final chrome = ControlChrome.resolve(
                  context,
                  state: state,
                  role: ControlRole.button,
                  emphasis: ControlEmphasis.primary,
                );
                expect(chrome.label, UiStateCatalog.of(state).label);
                expect(chrome.opacity, inInclusiveRange(0.0, 1.0));
                return Text(chrome.label);
              },
            ),
          );
        }
      }
    });
  });

  group('Mi controls paint every UiState', () {
    for (final entry in <(String, ThemeData)>[
      ('TV', AppTheme.tvDark()),
      ('Companion', AppTheme.companionLight()),
    ]) {
      final flavor = entry.$1;
      final theme = entry.$2;

      testWidgets('$flavor button / chip / toggle / list / field × 12', (
        tester,
      ) async {
        for (final state in UiState.values) {
          await pumpTheme(
            tester,
            theme: theme,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  MiButton(label: 'Go', state: state),
                  MiChip(label: 'Genre', state: state),
                  MiToggle(value: true, label: 'Autoplay', state: state),
                  MiListRow(
                    title: 'Row',
                    subtitle: 'Detail',
                    state: state,
                  ),
                  MiTextField(
                    label: 'Email',
                    hint: 'you@example.com',
                    state: state,
                  ),
                ],
              ),
            ),
          );
          expect(find.text('Go'), findsOneWidget);
          expect(find.text('Genre'), findsOneWidget);
          expect(find.text('Autoplay'), findsOneWidget);
          expect(find.text('Row'), findsOneWidget);
          expect(find.text('Email'), findsOneWidget);
          // Non-color status cue for non-resting states.
          if (state != UiState.defaults &&
              state != UiState.focused &&
              state != UiState.pressed) {
            expect(
              find.text(UiStateCatalog.of(state).label),
              findsWidgets,
              reason: '$flavor $state must expose catalog label cue',
            );
          }
        }
      });
    }
  });

  test('MiTextField.sanitize strips control characters', () {
    expect(MiTextField.sanitize('  hello\u0000world'), 'helloworld');
  });

  testWidgets('MiToggle invokes onChanged when interactive', (tester) async {
    var value = false;
    await pumpTheme(
      tester,
      theme: AppTheme.tvDark(),
      child: MiToggle(
        value: value,
        label: 'Sync',
        onChanged: (next) => value = next,
      ),
    );
    await tester.tap(find.text('Sync'));
    await tester.pumpAndSettle();
    expect(value, isTrue);
  });

  testWidgets('MiChip selected uses selected chrome', (tester) async {
    await pumpTheme(
      tester,
      theme: AppTheme.companionLight(),
      child: const MiChip(label: 'Live', selected: true),
    );
    expect(find.text('Live'), findsOneWidget);
    expect(find.text('Selected'), findsOneWidget);
  });

  testWidgets('MiTextField focused applies scale and focus glow', (tester) async {
    await pumpTheme(
      tester,
      theme: AppTheme.tvDark(),
      child: const MiTextField(label: 'Pin', state: UiState.focused),
    );
    final shell = tester.widget<AnimatedContainer>(
      find.descendant(
        of: find.byType(MiTextField),
        matching: find.byType(AnimatedContainer),
      ).first,
    );
    final decoration = shell.decoration! as BoxDecoration;
    expect(decoration.boxShadow, isNotNull);
    expect(decoration.boxShadow, isNotEmpty);
  });
}
