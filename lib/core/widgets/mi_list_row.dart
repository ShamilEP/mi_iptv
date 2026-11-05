import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'control_chrome.dart';
import 'control_shell.dart';
import 'focusable_surface.dart';
import 'ui_state.dart';

/// Settings / nav / channel list row (DSN-013).
class MiListRow extends StatelessWidget {
  const MiListRow({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onPressed,
    this.state = UiState.defaults,
    this.focusNode,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onPressed;
  final UiState state;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final chrome = ControlChrome.resolve(
      context,
      state: state,
      role: ControlRole.listRow,
    );
    final spec = FocusStyles.specFor(FocusControlKind.listRow);
    final body = _RowBody(
      title: title,
      subtitle: subtitle,
      leading: leading,
      trailing: trailing,
      chrome: chrome,
    );

    if (state == UiState.defaults) {
      return FocusableSurface(
        kind: FocusControlKind.listRow,
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

class _RowBody extends StatelessWidget {
  const _RowBody({
    required this.title,
    required this.chrome,
    this.subtitle,
    this.leading,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final ControlChrome chrome;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        if (leading != null) ...[
          leading!,
          const SizedBox(width: AppSpacing.sm),
        ] else if (chrome.leadingIcon != null || chrome.showProgress) ...[
          ControlStatusCue(chrome: chrome, compact: true),
          const SizedBox(width: AppSpacing.sm),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.titleLarge?.copyWith(color: chrome.foreground),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  subtitle!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.labelLarge?.copyWith(
                    color: context.brandColors.muted,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (chrome.statusLabel != null) ...[
          const SizedBox(width: AppSpacing.xs),
          Text(
            chrome.statusLabel!,
            style: textTheme.labelSmall?.copyWith(color: chrome.foreground),
          ),
        ],
        if (trailing != null) ...[
          const SizedBox(width: AppSpacing.xs),
          trailing!,
        ],
      ],
    );
  }
}
