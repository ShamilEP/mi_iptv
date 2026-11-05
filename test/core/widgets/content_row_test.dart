import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/app/app.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/core/widgets/content_card.dart';
import 'package:mi_iptv/core/widgets/content_row.dart';
import 'package:mi_iptv/core/widgets/content_row_list.dart';

void main() {
  Future<void> pumpRow(
    WidgetTester tester, {
    required Widget child,
  }) async {
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

  group('ContentRow DSN-012', () {
    testWidgets('renders title and cards', (tester) async {
      await pumpRow(
        tester,
        child: ContentRow(
          title: 'Continue watching',
          kind: ContentCardKind.continueWatching,
          itemCount: 2,
          itemBuilder: (context, index, focusNode) {
            return ContentCard(
              kind: ContentCardKind.continueWatching,
              title: 'Item $index',
              progress: 0.2,
              focusNode: focusNode,
            );
          },
        ),
      );

      expect(find.text('Continue watching'), findsOneWidget);
      expect(find.text('Item 0'), findsOneWidget);
      expect(find.text('Item 1'), findsOneWidget);
    });

    testWidgets('shows position cue when a card is focused', (tester) async {
      final rowKey = GlobalKey<ContentRowState>();
      await pumpRow(
        tester,
        child: ContentRow(
          key: rowKey,
          title: 'Featured',
          kind: ContentCardKind.poster,
          itemCount: 3,
          itemBuilder: (context, index, focusNode) {
            return ContentCard(
              kind: ContentCardKind.poster,
              title: 'P$index',
              focusNode: focusNode,
            );
          },
        ),
      );

      expect(
        find.byKey(const ValueKey<String>('content-row-position-cue')),
        findsNothing,
      );

      rowKey.currentState!.restoreLastFocus();
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey<String>('content-row-position-cue')),
        findsOneWidget,
      );
      expect(find.text('1 / 3'), findsOneWidget);
      expect(rowKey.currentState!.activeIndex, 0);
    });

    testWidgets('remembers last focused index across restore', (tester) async {
      final rowKey = GlobalKey<ContentRowState>();
      final nodes = <FocusNode>[];

      await pumpRow(
        tester,
        child: ContentRow(
          key: rowKey,
          title: 'Memory',
          storageId: 'test-memory-row',
          kind: ContentCardKind.landscape,
          itemCount: 3,
          itemBuilder: (context, index, focusNode) {
            if (nodes.length == index) {
              nodes.add(focusNode);
            }
            return ContentCard(
              kind: ContentCardKind.landscape,
              title: 'L$index',
              focusNode: focusNode,
            );
          },
        ),
      );
      await tester.pumpAndSettle();
      expect(nodes, hasLength(3));

      nodes[2].requestFocus();
      await tester.pumpAndSettle();
      expect(rowKey.currentState!.lastFocusedIndex, 2);
      expect(find.text('3 / 3'), findsOneWidget);

      nodes[2].unfocus();
      await tester.pumpAndSettle();
      expect(rowKey.currentState!.activeIndex, isNull);
      expect(rowKey.currentState!.lastFocusedIndex, 2);

      rowKey.currentState!.restoreLastFocus();
      await tester.pumpAndSettle();
      expect(rowKey.currentState!.activeIndex, 2);
      expect(find.text('3 / 3'), findsOneWidget);
    });

    testWidgets('renders lazy-load placeholders after items', (tester) async {
      await pumpRow(
        tester,
        child: ContentRow(
          title: 'Loading rail',
          kind: ContentCardKind.poster,
          itemCount: 1,
          placeholderCount: 2,
          itemBuilder: (context, index, focusNode) {
            return ContentCard(
              kind: ContentCardKind.poster,
              title: 'Only',
              focusNode: focusNode,
            );
          },
        ),
      );

      expect(find.text('Only'), findsOneWidget);
      expect(find.bySemanticsLabel('Loading'), findsNWidgets(2));
    });
  });

  group('ContentRowList DSN-012', () {
    testWidgets('anchors a finite number of rows', (tester) async {
      await pumpRow(
        tester,
        child: SizedBox(
          height: 800,
          child: ContentRowList(
            rowCount: 2,
            rowBuilder: (context, index) {
              return ContentRow(
                title: 'Row $index',
                storageId: 'list-row-$index',
                kind: ContentCardKind.channelTile,
                itemCount: 1,
                itemBuilder: (context, itemIndex, focusNode) {
                  return ContentCard(
                    kind: ContentCardKind.channelTile,
                    title: 'C$index',
                    focusNode: focusNode,
                  );
                },
              );
            },
          ),
        ),
      );

      expect(find.text('Row 0'), findsOneWidget);
      expect(find.text('Row 1'), findsOneWidget);
      expect(
        find.byKey(const ValueKey<String>('content-row-list-0')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('content-row-list-1')),
        findsOneWidget,
      );
    });
  });

  testWidgets('MiIptvApp boots with content rows on home', (tester) async {
    await tester.pumpWidget(const MiIptvApp());
    await tester.pumpAndSettle();
    expect(find.byType(ContentRow), findsWidgets);
    expect(find.byType(ContentRowList), findsOneWidget);
    expect(find.text('Continue watching'), findsOneWidget);
  });
}
