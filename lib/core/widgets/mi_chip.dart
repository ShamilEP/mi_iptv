import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'control_chrome.dart';
import 'control_shell.dart';
import 'focusable_surface.dart';
import 'ui_state.dart';

/// Compact filter / genre / LIVE chip (DSN-013).
class MiChip extends StatelessWidget {
  const MiChip({
    super.key,
    required this.label,
    this.onPressed,
    this.state = UiState.defaults,
    this.selected = false,
    this.focusNode,
  });

  final String label;
  final VoidCallback? onPressed;
  final UiState state;

  /// When true and [state] is [UiState.defaults], paints selected chrome.
  final bool selected;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final effective = selected && state == UiState.defaults
        ? UiState.selected
        : state;
    final chrome = ControlChrome.resolve(
      context,
      state: effective,
      role: ControlRole.chip,
      emphasis: effective == UiState.selected
          ? ControlEmphasis.primary
          : ControlEmphasis.secondary,
    );
    final spec = FocusStyles.specFor(FocusControlKind.chip);
    final body = _ChipBody(label: label, chrome: chrome);

    if (state == UiState.defaults && !selected) {
      return FocusableSurface(
        kind: FocusControlKind.chip,
        focusNode: focusNode,
        fill: chrome.fill,
        borderRadius: spec.borderRadius,
        padding: spec.contentPadding,
        onPressed: chrome.interactive ? onPressed : null,
        child: body,
      );
    }

    return ControlShell(
      chrome: chrome,
      borderRadius: spec.borderRadius,
      padding: spec.contentPadding,
      child: body,
    );
  }
}

class _ChipBody extends StatelessWidget {
  const _ChipBody({required this.label, required this.chrome});

  final String label;
  final ControlChrome chrome;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ControlStatusCue(chrome: chrome, compact: true),
        if (chrome.leadingIcon != null || chrome.showProgress)
          const SizedBox(width: AppSpacing.xxs),
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: chrome.foreground,
              ),
        ),
        if (chrome.statusLabel != null &&
            chrome.state != UiState.defaults &&
            chrome.state != UiState.focused &&
            chrome.state != UiState.pressed) ...[
          const SizedBox(width: AppSpacing.xxs),
          Text(
            chrome.statusLabel!,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: chrome.foreground,
                ),
          ),
        ],
      ],
    );
  }
}
