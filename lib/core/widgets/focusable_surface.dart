import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Shared TV D-pad focus wrapper (DSN-006).
///
/// Applies Cloud 4px ring + Signal glow + 1.05× scale for every
/// [FocusControlKind]. Prefer this over ad-hoc focus decorations.
class FocusableSurface extends StatefulWidget {
  const FocusableSurface({
    super.key,
    required this.child,
    this.onPressed,
    this.kind = FocusControlKind.card,
    this.borderRadius,
    this.fill,
    this.padding,
    this.applySpecPadding = false,
    this.focusNode,
    this.onFocusChange,
  });

  final Widget child;
  final VoidCallback? onPressed;

  /// Role used to resolve radius / fill from [FocusStyles.specFor].
  final FocusControlKind kind;

  /// Overrides [FocusControlSpec.borderRadius] when non-null.
  final double? borderRadius;

  /// Overrides [FocusControlSpec.fill] when non-null.
  final Color? fill;

  /// Explicit padding around [child]. When null and [applySpecPadding] is true,
  /// uses the kind's [FocusControlSpec.contentPadding].
  final EdgeInsetsGeometry? padding;

  /// When true (and [padding] is null), apply the kind's default content padding.
  final bool applySpecPadding;

  /// Optional external [FocusNode] (e.g. row last-focus memory).
  final FocusNode? focusNode;

  /// Notified when focus highlight visibility changes.
  final ValueChanged<bool>? onFocusChange;

  @override
  State<FocusableSurface> createState() => _FocusableSurfaceState();
}

class _FocusableSurfaceState extends State<FocusableSurface> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final spec = FocusStyles.specFor(widget.kind);
    final radius = widget.borderRadius ?? spec.borderRadius;
    final fill = widget.fill ?? spec.fill;
    final resolvedPadding = widget.padding ??
        (widget.applySpecPadding ? spec.contentPadding : null);

    Widget content = widget.child;
    if (resolvedPadding != null) {
      content = Padding(padding: resolvedPadding, child: content);
    }

    return FocusableActionDetector(
      focusNode: widget.focusNode,
      onShowFocusHighlight: (focused) {
        setState(() => _focused = focused);
        widget.onFocusChange?.call(focused);
      },
      actions: <Type, Action<Intent>>{
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            widget.onPressed?.call();
            return null;
          },
        ),
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onPressed,
        child: AnimatedScale(
          scale: _focused ? FocusStyles.scale : 1,
          duration: AppMotion.fast,
          curve: AppMotion.emphasized,
          child: AnimatedContainer(
            duration: AppMotion.fast,
            curve: AppMotion.emphasized,
            decoration: BoxDecoration(
              color: fill,
              borderRadius: BorderRadius.circular(radius),
              boxShadow: _focused ? FocusStyles.focusGlow() : null,
            ),
            child: content,
          ),
        ),
      ),
    );
  }
}
