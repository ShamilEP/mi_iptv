import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/theme/theme.dart';

/// Shared helpers for Companion touch automation (QA-026 / SRS §22).
abstract final class CompanionTouchHarness {
  static const Size phoneSize = Size(390, 1600);

  /// Runs [body] with [debugDefaultTargetPlatformOverride] set, then clears it.
  static Future<void> withPlatform(
    TargetPlatform platform,
    Future<void> Function() body,
  ) async {
    final previous = debugDefaultTargetPlatformOverride;
    debugDefaultTargetPlatformOverride = platform;
    try {
      await body();
    } finally {
      debugDefaultTargetPlatformOverride = previous;
    }
  }

  static Future<void> pumpCompanion(
    WidgetTester tester, {
    required Widget home,
    Size size = phoneSize,
  }) async {
    await tester.binding.setSurfaceSize(size);
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.companionLight(),
        home: home,
      ),
    );
    await tester.pump();
  }
}
