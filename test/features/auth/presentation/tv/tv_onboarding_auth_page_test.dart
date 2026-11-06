import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/core/widgets/type_from_phone_hint.dart';
import 'package:mi_iptv/features/auth/presentation/tv/tv_onboarding_auth_page.dart';
import 'package:mi_iptv/features/auth/presentation/tv/tv_onboarding_auth_step.dart';

void main() {
  Future<void> pump(WidgetTester tester, {TvOnboardingAuthStep? step}) async {
    await tester.binding.setSurfaceSize(const Size(1920, 1080));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.tvDark(),
        home: TvOnboardingAuthPage(
          initialStep: step ?? TvOnboardingAuthStep.registerLogin,
        ),
      ),
    );
  }

  test('DSN-031 step copy locks DoD titles', () {
    expect(
      TvOnboardingAuthCopy.titleFor(TvOnboardingAuthStep.registerLogin),
      'Register / Login',
    );
    expect(
      TvOnboardingAuthCopy.titleFor(TvOnboardingAuthStep.preferences),
      'Preferences',
    );
    expect(
      TvOnboardingAuthCopy.titleFor(TvOnboardingAuthStep.addSource),
      'Add source',
    );
    expect(
      TvOnboardingAuthCopy.titleFor(TvOnboardingAuthStep.validationResult),
      'Validation result',
    );
    expect(
      TvOnboardingAuthCopy.titleFor(TvOnboardingAuthStep.continueLater),
      'Continue later',
    );
  });

  testWidgets('register/login shows Companion text hint and auth actions', (
    tester,
  ) async {
    await pump(tester);

    expect(find.text('Register / Login'), findsOneWidget);
    expect(find.text(TypeFromPhoneHint.defaultLabel), findsWidgets);
    expect(find.text(TvOnboardingAuthCopy.loginLabel), findsOneWidget);
    expect(find.text(TvOnboardingAuthCopy.registerLabel), findsOneWidget);
    expect(find.text(TvOnboardingAuthCopy.continueLaterLabel), findsOneWidget);
  });

  testWidgets('Continue later navigates to continue-later step', (tester) async {
    await pump(tester);

    await tester.tap(find.text(TvOnboardingAuthCopy.continueLaterLabel));
    await tester.pumpAndSettle();

    expect(find.text('Continue later'), findsWidgets);
    expect(
      find.text(
        'You can finish register/login, preferences, and sources anytime.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('preferences continue advances to add source', (tester) async {
    await pump(tester, step: TvOnboardingAuthStep.preferences);

    await tester.tap(find.text(TvOnboardingAuthCopy.continueLabel));
    await tester.pumpAndSettle();

    expect(find.text('Add source'), findsOneWidget);
    expect(find.text(TvOnboardingAuthCopy.validateLabel), findsOneWidget);
  });
}
