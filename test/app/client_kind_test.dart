import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/app/app.dart';
import 'package:mi_iptv/app/client_kind.dart';
import 'package:mi_iptv/features/catalog/presentation/companion/companion_explore_page.dart';
import 'package:mi_iptv/features/home/presentation/tv/tv_home_page.dart';

void main() {
  test('ClientKind exposes tv and companion surfaces', () {
    expect(ClientKind.values, containsAll(<ClientKind>[ClientKind.tv, ClientKind.companion]));
  });

  testWidgets('TV client shows TvHomePage', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1920, 1080));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const MiIptvApp(clientKind: ClientKind.tv));
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
