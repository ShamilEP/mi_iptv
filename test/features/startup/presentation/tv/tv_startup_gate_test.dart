import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/app/navigation/app_routes.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/core/widgets/brand_lockup.dart';
import 'package:mi_iptv/features/auth/presentation/tv/tv_onboarding_auth_page.dart';
import 'package:mi_iptv/features/home/presentation/tv/tv_home_connectivity_binder.dart';
import 'package:mi_iptv/features/startup/domain/entities/startup_destination.dart';
import 'package:mi_iptv/features/startup/presentation/tv/tv_startup_gate.dart';
import 'package:mi_iptv/app/client_kind.dart';
import 'package:mi_iptv/app/navigation/app_navigator.dart';

void main() {
  testWidgets('TV-020 gate routes to Home when session resolves home', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1920, 1080));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.tvDark(),
        initialRoute: AppRoutes.tvSplash,
        onGenerateRoute: (settings) {
          if (settings.name == AppRoutes.tvSplash) {
            return MaterialPageRoute<void>(
              settings: settings,
              builder: (_) => TvStartupGate(
                splashHold: const Duration(milliseconds: 20),
                runStartup: () async => StartupDestination.home,
              ),
            );
          }
          return AppNavigator.onGenerateRoute(
            settings,
            clientKind: ClientKind.tv,
          );
        },
      ),
    );

    expect(find.byType(BrandLockup), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 20));
    await tester.pumpAndSettle();

    expect(find.byType(TvHomeConnectivityBinder), findsOneWidget);
    expect(find.byType(TvStartupGate), findsNothing);
  });

  testWidgets('TV-020 gate routes to Onboarding when session missing', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1920, 1080));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.tvDark(),
        initialRoute: AppRoutes.tvSplash,
        onGenerateRoute: (settings) {
          if (settings.name == AppRoutes.tvSplash) {
            return MaterialPageRoute<void>(
              settings: settings,
              builder: (_) => TvStartupGate(
                splashHold: const Duration(milliseconds: 20),
                runStartup: () async => StartupDestination.onboarding,
              ),
            );
          }
          return AppNavigator.onGenerateRoute(
            settings,
            clientKind: ClientKind.tv,
          );
        },
      ),
    );

    await tester.pump(const Duration(milliseconds: 20));
    await tester.pumpAndSettle();

    expect(find.byType(TvOnboardingAuthPage), findsOneWidget);
    expect(find.byType(TvStartupGate), findsNothing);
  });
}
