import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/mi_icon.dart';

/// One remote control with immediate press color and caller-supplied haptic.
class CompanionRemoteKey extends StatefulWidget {
  const CompanionRemoteKey({
    super.key,
    required this.label,
    required this.onPressed,
    required this.onFeedback,
    this.icon,
    this.large = false,
  });

  /// Visible control name.
  final String label;

  /// Called when the press completes.
  final VoidCallback onPressed;

  /// Haptic (or test double) fired as the press starts.
  final Future<void> Function() onFeedback;

  /// Optional catalog glyph shown with [label].
  final IconRole? icon;

  /// Square D-pad size when true.
  final bool large;

  @override
  State<CompanionRemoteKey> createState() => _CompanionRemoteKeyState();
}

class _CompanionRemoteKeyState extends State<CompanionRemoteKey> {
  bool _pressed = false;

  void _down() {
    setState(() => _pressed = true);
    widget.onFeedback();
  }

  void _up({required bool fire}) {
    if (_pressed) setState(() => _pressed = false);
    if (fire) widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final foreground = brand.cloud;
    final fill = _pressed ? brand.primary : brand.ink;

    return Semantics(
      button: true,
      label: widget.label,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _down(),
        onTapUp: (_) => _up(fire: true),
        onTapCancel: () => _up(fire: false),
        child: AnimatedContainer(
          key: ValueKey<String>('remote-key-${widget.label}'),
          duration: AppMotion.durationOf(context, AppMotion.fast),
          curve: AppMotion.curveOf(context, AppMotion.emphasized),
          width: widget.large ? AppSpacing.xxxl : null,
          height: widget.large ? AppSpacing.xxxl : null,
          padding: widget.large
              ? const EdgeInsets.all(AppSpacing.xxs)
              : const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.md,
                ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: brand.border),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.icon != null) ...[
                  MiIcon(
                    role: widget.icon!,
                    color: foreground,
                    size: AppSpacing.lg,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                ],
                Text(
                  widget.label,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.labelLarge
                      ?.copyWith(color: foreground),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
