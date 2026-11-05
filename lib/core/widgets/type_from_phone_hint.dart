import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'focusable_surface.dart';

/// Shortcut affordance: type from your phone / Companion keyboard (DSN-014).
///
/// Uses Ember / companionLive (send-to-TV / companion cue) plus label — state ≠
/// hue alone.
class TypeFromPhoneHint extends StatelessWidget {
  const TypeFromPhoneHint({
    super.key,
    this.label = 'Type from your phone',
    this.onPressed,
    this.focusNode,
  });

  final String label;
  final VoidCallback? onPressed;
  final FocusNode? focusNode;

  static const String defaultLabel = 'Type from your phone';

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final companion = Theme.of(context).brightness == Brightness.light;
    final accent = SemanticColorUsage.resolve(
      SemanticColorRole.liveAlert,
      companion: companion,
    );

    return FocusableSurface(
      kind: FocusControlKind.chip,
      focusNode: focusNode,
      fill: brand.panel,
      borderRadius: AppRadius.full,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.phone_android,
            size: AppSpacing.md,
            color: accent,
            semanticLabel: label,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: brand.cloud,
                ),
          ),
        ],
      ),
    );
  }
}
