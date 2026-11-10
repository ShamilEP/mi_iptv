import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// TV playback subtitle / caption chrome (DSN-021).
///
/// Renders [text] with locked size, Cloud foreground, and Ink scrim background.
/// Place near the lower third of the video stage; keep clear of bottom transport
/// bands. OS text scale is honored through [MediaQuery] (wrap with
/// [TvAccessibleScope] where supported).
class MiSubtitleCaption extends StatelessWidget {
  const MiSubtitleCaption({
    super.key,
    required this.text,
    this.size = SubtitleSizePreset.standard,
    this.maxLines = 3,
  });

  final String text;
  final SubtitleSizePreset size;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    if (text.trim().isEmpty) return const SizedBox.shrink();

    return Semantics(
      label: text,
      liveRegion: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppSubtitleStyle.background,
          borderRadius: AppSubtitleStyle.borderRadius,
        ),
        child: Padding(
          padding: AppSubtitleStyle.padding,
          child: Text(
            text,
            textAlign: TextAlign.center,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            style: AppSubtitleStyle.textStyle(size),
          ),
        ),
      ),
    );
  }
}
