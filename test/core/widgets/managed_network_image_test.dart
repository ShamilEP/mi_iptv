import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/core/widgets/content_card_metrics.dart';
import 'package:mi_iptv/core/widgets/content_card_skeleton.dart';
import 'package:mi_iptv/core/widgets/managed_network_image.dart';

void main() {
  testWidgets('TV-012 rejects non-HTTPS with error panel (no skeleton hang)', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.tvDark(),
        home: const Scaffold(
          body: ManagedNetworkImage(
            url: 'http://cdn.example/poster.jpg',
            kind: ContentCardKind.poster,
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(ContentCardSkeleton), findsNothing);
    expect(find.byIcon(Icons.broken_image_outlined), findsOneWidget);
  });

  testWidgets('TV-012 invalid URL shows error panel', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.tvDark(),
        home: const Scaffold(
          body: ManagedNetworkImage(
            url: 'not-a-url',
            kind: ContentCardKind.landscape,
          ),
        ),
      ),
    );
    await tester.pump();
    expect(find.byIcon(Icons.broken_image_outlined), findsOneWidget);
  });
}
