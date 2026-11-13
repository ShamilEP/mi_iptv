import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/app/app.dart';
import 'package:mi_iptv/app/client_kind.dart';
import 'package:mi_iptv/app/navigation/app_routes.dart';
import 'package:mi_iptv/features/catalog/presentation/companion/companion_explore_page.dart';
import 'package:mi_iptv/features/home/presentation/tv/tv_home_page.dart';
import 'package:mi_iptv/features/startup/presentation/tv/tv_startup_gate.dart';

void main() {
  test('ClientKind exposes tv and companion surfaces', () {
    expect(ClientKind.values, containsAll(<ClientKind>[ClientKind.tv, ClientKind.companion]));
  });

  testWidgets('TV client starts on splash gate', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1920, 1080));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const MiIptvApp(clientKind: ClientKind.tv));
    await tester.pump();
    expect(find.byType(TvStartupGate), findsOneWidget);
    expect(find.byType(CompanionExplorePage), findsNothing);
  });

  testWidgets('TV client shows TvHomePage when routed to home', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1920, 1080));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      const MiIptvApp(
        clientKind: ClientKind.tv,
        initialRoute: AppRoutes.home,
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(TvHomePage), findsOneWidget);
    expect(find.byType(CompanionExplorePage), findsNothing);
  });

  testWidgets('Companion client shows CompanionExplorePage', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const MiIptvApp(clientKind: ClientKind.companion));
    await tester.pumpAndSettle();
    expect(find.byType(CompanionExplorePage), findsOneWidget);
    expect(find.byType(TvHomePage), findsNothing);
  });
}
