import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'focusable_surface.dart';

/// Single TV on-screen keyboard key with DSN-006 [FocusControlKind.keyboardKey]
/// focus chrome (DSN-014).
class TvOskKey extends StatelessWidget {
  const TvOskKey({
    super.key,
    required this.label,
    this.semanticLabel,
    this.onPressed,
    this.focusNode,
    this.expanded = false,
    this.autofocus = false,
  });

  final String label;
  final String? semanticLabel;
  final VoidCallback? onPressed;
  final FocusNode? focusNode;
  final bool expanded;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final spec = FocusStyles.specFor(FocusControlKind.keyboardKey);

    Widget key = FocusableSurface(
      kind: FocusControlKind.keyboardKey,
      focusNode: focusNode,
      fill: brand.panel,
      borderRadius: spec.borderRadius,
      padding: spec.contentPadding,
      onPressed: onPressed,
      child: Center(
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: brand.cloud,
              ),
        ),
      ),
    );

    if (autofocus) {
      key = Focus(autofocus: true, child: key);
    }

    return Semantics(
      button: true,
      label: semanticLabel ?? label,
      child: sized(key),
    );
  }

  Widget sized(Widget child) {
    if (expanded) {
      return SizedBox(height: AppSpacing.xxl, child: child);
    }
    return SizedBox(
      width: AppSpacing.xxl,
      height: AppSpacing.xxl,
      child: child,
    );
  }
}
