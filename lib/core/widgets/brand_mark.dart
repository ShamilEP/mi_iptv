import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/brand_assets.dart';

/// Canonical Mi IPTV mark (signal arches + LIVE beacon).
///
/// Paints the Logo sheet geometry; do not invent alternate marks in UI.
class BrandMark extends StatelessWidget {
  const BrandMark({
    super.key,
    this.height = 48,
    this.tone = BrandMarkTone.dark,
    this.semanticLabel = 'Mi IPTV',
  }) : assert(height >= BrandAssets.minMarkSize);

  /// Rendered height in logical pixels (width follows viewBox aspect).
  final double height;

  final BrandMarkTone tone;
  final String? semanticLabel;

  double get width =>
      height * (BrandAssets.viewBoxWidth / BrandAssets.viewBoxHeight);

  @override
  Widget build(BuildContext context) {
    final colors = _BrandMarkColors.of(tone);
    return Semantics(
      label: semanticLabel,
      image: true,
      child: CustomPaint(
        size: Size(width, height),
        painter: BrandMarkPainter(
          stroke: colors.stroke,
          liveDot: colors.liveDot,
        ),
      ),
    );
  }
}

class _BrandMarkColors {
  const _BrandMarkColors({required this.stroke, required this.liveDot});

  final Color stroke;
  final Color liveDot;

  static _BrandMarkColors of(BrandMarkTone tone) {
    return switch (tone) {
      BrandMarkTone.dark => const _BrandMarkColors(
        stroke: AppColors.signal,
        liveDot: AppColors.ember,
      ),
      BrandMarkTone.companion => const _BrandMarkColors(
        stroke: AppColors.companionPrimary,
        liveDot: AppColors.companionLive,
      ),
      BrandMarkTone.monochrome => const _BrandMarkColors(
        stroke: AppColors.ink,
        liveDot: AppColors.ink,
      ),
    };
  }
}

/// Paints the DSN-005 mark into [BrandAssets] viewBox coordinates.
class BrandMarkPainter extends CustomPainter {
  const BrandMarkPainter({required this.stroke, required this.liveDot});

  final Color stroke;
  final Color liveDot;

  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / BrandAssets.viewBoxWidth;
    final sy = size.height / BrandAssets.viewBoxHeight;
    canvas.scale(sx, sy);

    final paint = Paint()
      ..color = stroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = BrandAssets.strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;

    final path = Path()
      // Left stem + upright arch + middle stem.
      ..moveTo(10, 48)
      ..lineTo(10, 30)
      ..arcTo(
        Rect.fromCircle(center: const Offset(19, 30), radius: 9),
        math.pi,
        -math.pi,
        false,
      )
      ..lineTo(28, 48)
      // Second arch + right stem of "m".
      ..moveTo(28, 30)
      ..arcTo(
        Rect.fromCircle(center: const Offset(37, 30), radius: 9),
        math.pi,
        -math.pi,
        false,
      )
      ..lineTo(46, 48)
      // "i" stem.
      ..moveTo(60, 33)
      ..lineTo(60, 48);

    canvas.drawPath(path, paint);

    canvas.drawCircle(
      const Offset(60, 19),
      BrandAssets.liveDotRadius,
      Paint()
        ..color = liveDot
        ..style = PaintingStyle.fill
        ..isAntiAlias = true,
    );
  }

  @override
  bool shouldRepaint(covariant BrandMarkPainter oldDelegate) {
    return oldDelegate.stroke != stroke || oldDelegate.liveDot != liveDot;
  }
}
