import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/theme/theme.dart';

/// Shared pump helpers for Design System visual regression (QA-029).
///
/// Uses Flutter's built-in [matchesGoldenFile] only — no golden toolkits.
/// Baselines are generated on Linux so CI (`ubuntu-latest`) matches pixels.
abstract final class VisualRegressionHarness {
  /// Fixed logical size for catalog / focus canvases (1080p-friendly scale).
  static const Size canvasSize = Size(960, 540);

  /// Directory for checked-in PNG baselines (relative to this test file).
  static const String goldenDir = 'goldens';

  /// True when this process should assert against PNG baselines.
  ///
  /// Goldens are authored for Linux (CI). Local Windows/macOS runs skip pixel
  /// compare unless `UPDATE_GOLDENS=1` is set (regenerate via Docker — see docs).
  static bool get shouldCompareGoldens {
    if (autoUpdateGoldenFiles) return true;
    if (Platform.environment['UPDATE_GOLDENS'] == '1') return true;
    return !kIsWeb && Platform.isLinux;
  }

  static String goldenPath(String name) => '$goldenDir/$name.png';

  /// Pumps [child] under TV dark theme with animations frozen for stable pixels.
  static Future<void> pumpTvCanvas(
    WidgetTester tester, {
    required Widget child,
    Size size = canvasSize,
    Color? background,
  }) async {
    final view = tester.view;
    view.physicalSize = Size(
      size.width * view.devicePixelRatio,
      size.height * view.devicePixelRatio,
    );
    view.platformDispatcher.textScaleFactorTestValue = 1.0;
    addTearDown(view.resetPhysicalSize);
    addTearDown(view.platformDispatcher.clearTextScaleFactorTestValue);

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.tvDark(),
        home: MediaQuery(
          data: MediaQueryData(
            size: size,
            disableAnimations: true,
            boldText: false,
            accessibleNavigation: false,
          ),
          child: TickerMode(
            enabled: false,
            child: Scaffold(
              backgroundColor: background ?? AppColors.ink,
              body: Center(child: child),
            ),
          ),
        ),
      ),
    );
    // One frame only — tickers disabled; avoid pumpAndSettle on progress.
    await tester.pump();
  }

  /// Captures [finder] (or the whole screen) against a checked-in baseline.
  static Future<void> expectGolden(
    WidgetTester tester,
    String name, {
    Finder? of,
  }) async {
    if (!shouldCompareGoldens) {
      // Still paint so regressions in build/layout fail locally.
      expect(tester.takeException(), isNull);
      return;
    }
    await expectLater(
      of ?? find.byType(MaterialApp),
      matchesGoldenFile(goldenPath(name)),
    );
  }
}
