import 'package:flutter/material.dart';

import '../theme/brand_assets.dart';
import 'brand_mark.dart';
import 'brand_wordmark.dart';

/// Horizontal mark + `iptv` wordmark with clear-space gap.
class BrandLockup extends StatelessWidget {
  const BrandLockup({
    super.key,
    this.markHeight = 48,
    this.tone = BrandMarkTone.dark,
    this.wordmarkColor,
    this.semanticLabel = 'Mi IPTV',
  }) : assert(markHeight >= BrandAssets.minMarkSize);

  final double markHeight;
  final BrandMarkTone tone;
  final Color? wordmarkColor;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final mark = BrandMark(height: markHeight, tone: tone, semanticLabel: null);
    final gap = markHeight * (BrandAssets.clearSpaceUnit / BrandAssets.viewBoxHeight);
    final wordSize = markHeight * (62 / 57);

    return Semantics(
      label: semanticLabel,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          mark,
          SizedBox(width: gap),
          BrandWordmark(
            fontSize: wordSize,
            tone: tone,
            color: wordmarkColor,
          ),
        ],
      ),
    );
  }
}
