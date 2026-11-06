import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Renders a catalog [IconRole] with the DSN-019 labeling rule.
///
/// When [IconographyEntry.labelRequired] is true, a visible text label is
/// always shown (ambiguous meaning). Otherwise the label is optional and
/// defaults to semantics-only via [Icon.semanticLabel].
class MiIcon extends StatelessWidget {
  const MiIcon({
    super.key,
    required this.role,
    this.label,
    this.showLabel = false,
    this.size,
    this.color,
  });

  final IconRole role;

  /// Override catalog default label.
  final String? label;

  /// When true, always show the label. Ignored when [IconographyEntry.labelRequired]
  /// is true (ambiguous icons cannot hide the text label).
  final bool showLabel;

  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final entry = Iconography.of(role);
    final text = label ?? entry.label;
    final visible = entry.labelRequired || showLabel;
    final brand = context.brandColors;
    final iconColor = color ?? brand.cloud;
    final iconSize = size ?? AppSpacing.md;

    final glyph = Icon(
      entry.icon,
      size: iconSize,
      color: iconColor,
      semanticLabel: text,
    );

    if (!visible) {
      return glyph;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        glyph,
        const SizedBox(width: AppSpacing.xxs),
        Text(
          text,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: iconColor,
              ),
        ),
      ],
    );
  }
}
