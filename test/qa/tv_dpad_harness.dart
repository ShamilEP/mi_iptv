import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/theme/theme.dart';

/// Shared helpers for TV D-pad navigation automation (QA-025 / SRS §12).
abstract final class TvDpadHarness {
  static Future<void> pumpTv(
    WidgetTester tester, {
    required Widget home,
    Size size = const Size(1920, 1080),
  }) async {
    await tester.binding.setSurfaceSize(size);
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.tvDark(),
        home: home,
      ),
    );
    await tester.pumpAndSettle();
  }

  /// Visible [Text] labels under the current primary focus subtree.
  static List<String> focusedLabels() {
    final focus = FocusManager.instance.primaryFocus;
    final context = focus?.context;
    if (context == null) return const <String>[];

    final labels = <String>[];
    void walk(Element element) {
      final widget = element.widget;
      if (widget is Text) {
        final data = widget.data;
        if (data != null && data.trim().isNotEmpty) {
          labels.add(data);
        }
      }
      element.visitChildren(walk);
    }

    walk(context as Element);
    return List<String>.unmodifiable(labels);
  }

  static Future<void> press(
    WidgetTester tester,
    LogicalKeyboardKey key,
  ) async {
    await tester.sendKeyEvent(key);
    await tester.pumpAndSettle();
  }
}
