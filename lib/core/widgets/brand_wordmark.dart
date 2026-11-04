import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/brand_assets.dart';

/// Lowercase `iptv` wordmark (Bricolage Grotesque 700, −3% tracking).
class BrandWordmark extends StatelessWidget {
  const BrandWordmark({
    super.key,
    this.fontSize = 40,
    this.color,
    this.tone = BrandMarkTone.dark,
  });

  final double fontSize;
  final Color? color;
  final BrandMarkTone tone;

  @override
  Widget build(BuildContext context) {
    final resolved =
        color ??
        switch (tone) {
          BrandMarkTone.dark => AppColors.cloud,
          BrandMarkTone.companion => AppColors.ink,
          BrandMarkTone.monochrome => AppColors.ink,
        };

    return Text(
      BrandAssets.wordmarkText,
      style: TextStyle(
        fontFamily: AppTypography.displayFamily,
        fontFamilyFallback: AppTypography.displayFallbacks,
        fontWeight: FontWeight.w700,
        fontSize: fontSize,
        height: 1,
        letterSpacing: fontSize * BrandAssets.wordmarkTrackingEm,
        color: resolved,
      ),
    );
  }
}
