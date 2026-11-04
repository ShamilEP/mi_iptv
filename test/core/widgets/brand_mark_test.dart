import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/theme/brand_assets.dart';
import 'package:mi_iptv/core/widgets/brand_lockup.dart';
import 'package:mi_iptv/core/widgets/brand_mark.dart';
import 'package:mi_iptv/core/widgets/brand_wordmark.dart';

void main() {
  testWidgets('BrandMark paints at requested height', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: BrandMark(height: 48),
        ),
      ),
    );

    final mark = tester.widget<BrandMark>(find.byType(BrandMark));
    expect(mark.height, 48);
    expect(mark.width, closeTo(48 * 72 / 64, 0.01));
    expect(
      find.descendant(
        of: find.byType(BrandMark),
        matching: find.byType(CustomPaint),
      ),
      findsOneWidget,
    );
  });

  testWidgets('BrandWordmark renders lowercase iptv', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: BrandWordmark(fontSize: 40),
        ),
      ),
    );

    expect(find.text(BrandAssets.wordmarkText), findsOneWidget);
  });

  testWidgets('BrandLockup combines mark and wordmark', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: BrandLockup(markHeight: 40),
        ),
      ),
    );

    expect(find.byType(BrandMark), findsOneWidget);
    expect(find.byType(BrandWordmark), findsOneWidget);
    expect(find.text('iptv'), findsOneWidget);
  });
}
