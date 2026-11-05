import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'control_chrome.dart';
import 'control_shell.dart';
import 'focusable_surface.dart';
import 'ui_state.dart';

/// Brand button for TV and Companion (DSN-013).
///
/// Pass [state] to lock any of the 12 mandatory UI states for demos / catalogs.
/// When [state] is [UiState.defaults], live focus chrome comes from
/// [FocusableSurface].
class MiButton extends StatelessWidget {
  const MiButton({
    super.key,
    required this.label,
    this.onPressed,
    this.state = UiState.defaults,
    this.emphasis = ControlEmphasis.primary,
    this.focusNode,
  });

  final String label;
  final VoidCallback? onPressed;
  final UiState state;
  final ControlEmphasis emphasis;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final chrome = ControlChrome.resolve(
      context,
      state: state,
      role: ControlRole.button,
      emphasis: emphasis,
    );
    final spec = FocusStyles.specFor(FocusControlKind.button);
    final body = _ButtonBody(label: label, chrome: chrome);

    if (state == UiState.defaults) {
      return FocusableSurface(
        kind: FocusControlKind.button,
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

class _ButtonBody extends StatelessWidget {
  const _ButtonBody({required this.label, required this.chrome});

  final String label;
  final ControlChrome chrome;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ControlStatusCue(chrome: chrome, compact: true),
        if (chrome.leadingIcon != null || chrome.showProgress)
          const SizedBox(width: AppSpacing.xs),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: chrome.foreground,
                ),
          ),
        ),
        if (chrome.statusLabel != null &&
            chrome.state != UiState.defaults &&
            chrome.state != UiState.focused &&
            chrome.state != UiState.pressed) ...[
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
  }
}
