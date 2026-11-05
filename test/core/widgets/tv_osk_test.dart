import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/core/widgets/focusable_surface.dart';
import 'package:mi_iptv/core/widgets/tv_on_screen_keyboard.dart';
import 'package:mi_iptv/core/widgets/tv_osk_key.dart';
import 'package:mi_iptv/core/widgets/type_from_phone_hint.dart';

void main() {
  Future<void> pumpOsk(
    WidgetTester tester, {
    required Widget child,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.tvDark(),
        home: Scaffold(
          backgroundColor: AppColors.ink,
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: child,
          ),
        ),
      ),
    );
  }

  testWidgets('TV OSK keys use keyboardKey focus kind', (tester) async {
    await pumpOsk(
      tester,
      child: const TvOskKey(label: 'A'),
    );
    final surface = tester.widget<FocusableSurface>(
      find.byType(FocusableSurface),
    );
    expect(surface.kind, FocusControlKind.keyboardKey);
  });

  testWidgets('TypeFromPhoneHint shows companion shortcut label', (tester) async {
    var tapped = false;
    await pumpOsk(
      tester,
      child: TypeFromPhoneHint(onPressed: () => tapped = true),
    );
    expect(find.text(TypeFromPhoneHint.defaultLabel), findsOneWidget);
    expect(find.byIcon(Icons.phone_android), findsOneWidget);
    await tester.tap(find.text(TypeFromPhoneHint.defaultLabel));
    await tester.pumpAndSettle();
    expect(tapped, isTrue);
  });

  testWidgets('TvOnScreenKeyboard types letters and respects focus order', (
    tester,
  ) async {
    final key = GlobalKey<TvOnScreenKeyboardState>();
    await pumpOsk(
      tester,
      child: TvOnScreenKeyboard(
        key: key,
        fieldLabel: 'Email',
      ),
    );

    expect(find.byType(FocusTraversalGroup), findsWidgets);
    expect(find.byType(FocusTraversalOrder), findsWidgets);
    expect(find.text(TypeFromPhoneHint.defaultLabel), findsOneWidget);

    await tester.tap(find.text('a'));
    await tester.pumpAndSettle();
    expect(key.currentState!.text, 'a');

    await tester.tap(find.text('abc'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('B'));
    await tester.pumpAndSettle();
    expect(key.currentState!.text, 'aB');
  });

  testWidgets('masked password entry hides characters in the field', (
    tester,
  ) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);

    await pumpOsk(
      tester,
      child: TvOnScreenKeyboard(
        controller: controller,
        obscureText: true,
        fieldLabel: 'Password',
        showTypeFromPhoneHint: true,
      ),
    );

    expect(find.byType(TvOnScreenKeyboard), findsOneWidget);
    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.obscureText, isTrue);

    await tester.tap(find.text('p'));
    await tester.pumpAndSettle();
    expect(controller.text, 'p');
    // Obscuring is on the TextField; plaintext stays in the controller.
    expect(find.text('p'), findsWidgets); // key label still visible
  });

  testWidgets('backspace and space actions update buffer', (tester) async {
    final key = GlobalKey<TvOnScreenKeyboardState>();
    await pumpOsk(
      tester,
      child: TvOnScreenKeyboard(key: key),
    );

    key.currentState!.insertCharacter('A');
    key.currentState!.insertSpace();
    key.currentState!.insertCharacter('B');
    await tester.pump();
    expect(key.currentState!.text, 'a b');

    key.currentState!.backspace();
    await tester.pump();
    expect(key.currentState!.text, 'a ');
  });
}
