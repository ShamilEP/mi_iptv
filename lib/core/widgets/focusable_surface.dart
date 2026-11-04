import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/focus_styles.dart';

/// Minimal shared focus wrapper for TV D-pad targets.
class FocusableSurface extends StatefulWidget {
  const FocusableSurface({
    super.key,
    required this.child,
    this.onPressed,
    this.borderRadius = 16,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final double borderRadius;

  @override
  State<FocusableSurface> createState() => _FocusableSurfaceState();
}

class _FocusableSurfaceState extends State<FocusableSurface> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      onShowFocusHighlight: (focused) => setState(() => _focused = focused),
      actions: <Type, Action<Intent>>{
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            widget.onPressed?.call();
            return null;
          },
        ),
      },
      child: AnimatedScale(
        scale: _focused ? FocusStyles.scale : 1,
        duration: const Duration(milliseconds: 120),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: _focused ? FocusStyles.focusGlow() : null,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
