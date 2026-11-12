import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/app/client_kind.dart';
import 'package:mi_iptv/app/navigation/app_navigator.dart';
import 'package:mi_iptv/app/navigation/app_routes.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/features/catalog/presentation/companion/companion_explore_page.dart';
import 'package:mi_iptv/features/devices/presentation/companion/companion_remote_page.dart';
import 'package:mi_iptv/features/home/presentation/tv/tv_home_page.dart';

void main() {
  test('AppRoutes.forClient splits TV and Companion', () {
    expect(AppRoutes.forClient(ClientKind.tv), contains(AppRoutes.tvLive));
    expect(AppRoutes.forClient(ClientKind.tv), contains(AppRoutes.tvFavorites));
    expect(
      AppRoutes.forClient(ClientKind.tv),
      contains(AppRoutes.tvContentDetail),
    );
    expect(AppRoutes.forClient(ClientKind.tv), contains(AppRoutes.tvVodPlayer));
    expect(
      AppRoutes.forClient(ClientKind.tv),
      isNot(contains(AppRoutes.companionRemote)),
    );
    expect(
      AppRoutes.forClient(ClientKind.companion),
      contains(AppRoutes.companionRemote),
    );
    expect(
      AppRoutes.forClient(ClientKind.companion),
      isNot(contains(AppRoutes.tvLive)),
    );
  });

  testWidgets('TV home route builds TvHomePage', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1920, 1080));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final route = AppNavigator.onGenerateRoute(
      const RouteSettings(name: AppRoutes.home),
      clientKind: ClientKind.tv,
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.tvDark(),
        onGenerateRoute: (_) => route,
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(TvHomePage), findsOneWidget);
  });

  testWidgets('Companion remote route builds CompanionRemotePage', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final route = AppNavigator.onGenerateRoute(
      const RouteSettings(name: AppRoutes.companionRemote),
      clientKind: ClientKind.companion,
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.companionLight(),
        onGenerateRoute: (_) => route,
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(CompanionRemotePage), findsOneWidget);
  });

  testWidgets('TV cannot open companion remote route', (tester) async {
    final route = AppNavigator.onGenerateRoute(
      const RouteSettings(name: AppRoutes.companionRemote),
      clientKind: ClientKind.tv,
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.tvDark(),
        onGenerateRoute: (_) => route,
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(CompanionRemotePage), findsNothing);
    expect(find.byType(CompanionExplorePage), findsNothing);
    expect(find.textContaining('not available'), findsOneWidget);
  });
}
