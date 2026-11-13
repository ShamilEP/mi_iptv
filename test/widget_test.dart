import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/app/app.dart';
import 'package:mi_iptv/app/navigation/app_routes.dart';

void main() {
  testWidgets('TV home renders brand lockup and Continue watching', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1920, 1080));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const MiIptvApp(initialRoute: AppRoutes.home));
    await tester.pumpAndSettle();
    expect(find.text('iptv'), findsOneWidget);
    expect(find.text('Continue watching'), findsOneWidget);
    expect(find.text('Live TV'), findsOneWidget);
  });
}
