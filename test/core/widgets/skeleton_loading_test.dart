import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/core/widgets/content_card.dart';
import 'package:mi_iptv/core/widgets/content_card_skeleton.dart';
import 'package:mi_iptv/core/widgets/content_row_skeleton.dart';
import 'package:mi_iptv/core/widgets/detail_skeleton.dart';
import 'package:mi_iptv/core/widgets/list_skeleton.dart';
import 'package:mi_iptv/core/widgets/loading_pattern.dart';
import 'package:mi_iptv/core/widgets/skeleton_block.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget child) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.tvDark(),
        home: Scaffold(
          backgroundColor: AppColors.ink,
          body: Center(child: child),
        ),
      ),
    );
  }

  testWidgets('ContentCardSkeleton matches ContentCardMetrics size', (
    tester,
  ) async {
    const kind = ContentCardKind.poster;
    final expected = ContentCardMetrics.sizeOf(kind);

    await pump(tester, const ContentCardSkeleton(kind: kind));
    final box = tester.getSize(find.byType(ContentCardSkeleton));
    expect(box.width, expected.width);
    expect(box.height, expected.height);
  });

  testWidgets('ContentRowSkeleton reserves stable height', (tester) async {
    const kind = ContentCardKind.landscape;
    final reserved = ContentRowSkeleton.reservedHeight(kind);
    expect(
      reserved,
      greaterThan(AppTypography.tvHeadlineLine + AppSpacing.stackTight),
    );

    await pump(
      tester,
      const SizedBox(
        width: 800,
        child: ContentRowSkeleton(kind: kind, slotCount: 3),
      ),
    );

    final box = tester.getSize(find.byType(ContentRowSkeleton));
    expect(box.height, reserved);
    expect(find.byType(ContentCardSkeleton), findsNWidgets(3));
  });

  testWidgets('DetailSkeleton and ListSkeleton keep reserved height', (
    tester,
  ) async {
    const detail = DetailSkeleton(lineCount: 3);
    const list = ListSkeleton(rowCount: 4);

    await pump(
      tester,
      SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [detail, SizedBox(height: 24), list],
        ),
      ),
    );

    expect(tester.getSize(find.byType(DetailSkeleton)).height, detail.reservedHeight);
    expect(tester.getSize(find.byType(ListSkeleton)).height, list.reservedHeight);
  });

  testWidgets('LoadingPattern shows progress and Loading label', (tester) async {
    await pump(tester, const LoadingPattern());
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Loading'), findsOneWidget);
    expect(tester.getSize(find.byType(LoadingPattern)).height, greaterThanOrEqualTo(48));
  });

  testWidgets('SkeletonBlock keeps fixed size', (tester) async {
    await pump(
      tester,
      const SkeletonBlock(width: 100, height: 40),
    );
    expect(tester.getSize(find.byType(SkeletonBlock)), const Size(100, 40));
  });
}
