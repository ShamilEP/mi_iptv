import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'control_chrome.dart';
import 'control_shell.dart';
import 'focusable_surface.dart';
import 'ui_state.dart';

/// Brand on/off toggle for TV and Companion (DSN-013).
class MiToggle extends StatelessWidget {
  const MiToggle({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.state = UiState.defaults,
    this.focusNode,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final UiState state;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final chrome = ControlChrome.resolve(
      context,
      state: state,
      role: ControlRole.toggle,
      emphasis: value ? ControlEmphasis.primary : ControlEmphasis.secondary,
    );
    final brand = context.brandColors;
    final trackColor = value ? brand.primary : brand.border;
    final thumbColor = value ? (chrome.foreground) : brand.cloud;

    final toggle = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ControlStatusCue(chrome: chrome, compact: true),
        if (chrome.leadingIcon != null || chrome.showProgress)
          const SizedBox(width: AppSpacing.xs),
        if (label != null) ...[
          Text(
            label!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: chrome.foreground,
                ),
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
        Semantics(
          label: label ?? 'Toggle',
          value: value ? 'On' : 'Off',
          toggled: value,
          child: AnimatedContainer(
            duration: AppMotion.fast,
            curve: AppMotion.emphasized,
            width: AppSpacing.xxl,
            height: AppSpacing.lg,
            padding: const EdgeInsets.all(AppSpacing.xxs),
            decoration: BoxDecoration(
              color: trackColor,
              borderRadius: BorderRadius.circular(AppRadius.full),
              border: Border.all(color: chrome.border),
            ),
            child: Align(
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: AppSpacing.md,
                height: AppSpacing.md,
                decoration: BoxDecoration(
                  color: thumbColor,
                  shape: BoxShape.circle,
                ),
                child: value
                    ? Icon(Icons.check, size: AppSpacing.sm, color: brand.ink)
                    : null,
              ),
            ),
          ),
        ),
        if (chrome.statusLabel != null) ...[
          const SizedBox(width: AppSpacing.xs),
          Text(
            chrome.statusLabel!,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: chrome.foreground,
                ),
          ),
        ],
      ],
    );

    VoidCallback? press;
    if (chrome.interactive && onChanged != null) {
      press = () => onChanged!(!value);
    }

    if (state == UiState.defaults) {
      return FocusableSurface(
        kind: FocusControlKind.button,
        focusNode: focusNode,
        fill: Colors.transparent,
        borderRadius: AppRadius.sm,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xs,
          vertical: AppSpacing.xxs,
        ),
        onPressed: press,
        child: toggle,
      );
    }

    return ControlShell(
      chrome: chrome,
      borderRadius: AppRadius.sm,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxs,
      ),
      child: toggle,
    );
  }
}
