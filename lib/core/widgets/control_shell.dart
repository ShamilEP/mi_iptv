import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'control_chrome.dart';

/// Shared painted shell for forced [UiState] chrome (DSN-013).
class ControlShell extends StatelessWidget {
  const ControlShell({
    super.key,
    required this.chrome,
    required this.borderRadius,
    required this.child,
    this.padding,
    this.width,
    this.height,
  });

  final ControlChrome chrome;
  final double borderRadius;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: chrome.opacity,
      child: Transform.scale(
        scale: chrome.scale,
        child: AnimatedContainer(
          duration: AppMotion.fast,
          curve: AppMotion.emphasized,
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            color: chrome.fill,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: chrome.border),
            boxShadow: chrome.showFocusGlow ? FocusStyles.focusGlow() : null,
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Leading status cue: progress or icon + optional label (state ≠ hue alone).
class ControlStatusCue extends StatelessWidget {
  const ControlStatusCue({
    super.key,
    required this.chrome,
    this.compact = false,
  });

  final ControlChrome chrome;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final color = chrome.foreground;
    final children = <Widget>[];

    if (chrome.showProgress) {
      children.add(
        SizedBox(
          width: AppSpacing.md,
          height: AppSpacing.md,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: color,
          ),
        ),
      );
    } else if (chrome.leadingIcon != null) {
      children.add(
        Icon(
          chrome.leadingIcon,
          size: AppSpacing.md,
          color: color,
          semanticLabel: chrome.statusLabel,
        ),
      );
    }

    if (!compact && chrome.statusLabel != null) {
      if (children.isNotEmpty) {
        children.add(const SizedBox(width: AppSpacing.xxs));
      }
      children.add(
        Text(
          chrome.statusLabel!,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(color: color),
        ),
      );
    }

    if (children.isEmpty) return const SizedBox.shrink();
    return Row(mainAxisSize: MainAxisSize.min, children: children);
  }
}
