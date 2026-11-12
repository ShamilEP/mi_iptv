import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/core/widgets/content_card.dart';
import 'package:mi_iptv/core/widgets/content_row.dart';
import 'package:mi_iptv/core/widgets/content_row_list.dart';
import 'package:mi_iptv/core/widgets/content_row_skeleton.dart';

/// Locks TV-031 row / carousel DoD against executable widgets.
void main() {
  Future<void> pump(WidgetTester tester, {required Widget child}) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.tvDark(),
        home: Scaffold(
          backgroundColor: AppColors.ink,
          body: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: child,
          ),
        ),
      ),
    );
  }

  testWidgets('lazy loading fires onNearEnd near the trailing cards', (
    tester,
  ) async {
    var nearEndCount = 0;
    final nodes = <FocusNode>[];

    await pump(
      tester,
      child: ContentRow(
        title: 'Paged',
        storageId: 'tv-031-near-end',
        kind: ContentCardKind.poster,
        itemCount: 4,
        placeholderCount: 2,
        nearEndThreshold: 2,
        onNearEnd: () => nearEndCount++,
        itemBuilder: (context, index, focusNode) {
          if (nodes.length == index) nodes.add(focusNode);
          return ContentCard(
            kind: ContentCardKind.poster,
            title: 'P$index',
            focusNode: focusNode,
          );
        },
      ),
    );
    await tester.pumpAndSettle();

    nodes[0].requestFocus();
    await tester.pumpAndSettle();
    expect(nearEndCount, 0);

    nodes[2].requestFocus();
    await tester.pumpAndSettle();
    expect(nearEndCount, 1);

    nodes[3].requestFocus();
    await tester.pumpAndSettle();
    expect(nearEndCount, 1);
    expect(find.bySemanticsLabel('Loading'), findsNWidgets(2));
  });

  testWidgets('skeletons reserve a stable full-rail height', (tester) async {
    const kind = ContentCardKind.landscape;
    final reserved = ContentRowSkeleton.reservedHeight(kind);

    await pump(
      tester,
      child: const ContentRowSkeleton(kind: kind, slotCount: 3),
    );

    expect(tester.getSize(find.byType(ContentRowSkeleton)).height, reserved);
  });

  testWidgets('position cue and last-focus memory survive restore', (
    tester,
  ) async {
    final rowKey = GlobalKey<ContentRowState>();
    final nodes = <FocusNode>[];

    await pump(
      tester,
      child: ContentRow(
        key: rowKey,
        title: 'Cue',
        storageId: 'tv-031-cue',
        kind: ContentCardKind.poster,
        itemCount: 3,
        itemBuilder: (context, index, focusNode) {
          if (nodes.length == index) nodes.add(focusNode);
          return ContentCard(
            kind: ContentCardKind.poster,
            title: 'C$index',
            focusNode: focusNode,
          );
        },
      ),
    );
    await tester.pumpAndSettle();

    nodes[1].requestFocus();
    await tester.pumpAndSettle();
    expect(find.text('2 / 3'), findsOneWidget);
    expect(rowKey.currentState!.lastFocusedIndex, 1);

    nodes[1].unfocus();
    await tester.pumpAndSettle();
    rowKey.currentState!.restoreLastFocus();
    await tester.pumpAndSettle();
    expect(rowKey.currentState!.activeIndex, 1);
    expect(find.text('2 / 3'), findsOneWidget);
  });

  testWidgets('ContentRowList rejects unanchored infinite scroll via rowCount', (
    tester,
  ) async {
    await pump(
      tester,
      child: SizedBox(
        height: 900,
        child: ContentRowList(
          rowCount: 2,
          rowBuilder: (context, index) {
            return ContentRow(
              title: 'Row $index',
              storageId: 'tv-031-list-$index',
              kind: ContentCardKind.channelTile,
              itemCount: 1,
              itemBuilder: (context, itemIndex, focusNode) {
                return ContentCard(
                  kind: ContentCardKind.channelTile,
                  title: 'T$index',
                  focusNode: focusNode,
                );
              },
            );
          },
        ),
      ),
    );

    expect(find.byType(ContentRow), findsNWidgets(2));
    expect(find.byKey(const ValueKey<String>('content-row-list-0')), findsOneWidget);
    expect(find.byKey(const ValueKey<String>('content-row-list-1')), findsOneWidget);
  });
}
