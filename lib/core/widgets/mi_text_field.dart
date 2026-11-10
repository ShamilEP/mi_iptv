import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'control_chrome.dart';
import 'control_shell.dart';
import 'ui_state.dart';

/// Brand text field for TV and Companion (DSN-013).
///
/// Validates lightly at the boundary: trims and rejects control characters in
/// the displayed value path when [onChanged] is used by callers.
class MiTextField extends StatelessWidget {
  const MiTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.onChanged,
    this.obscureText = false,
    this.state = UiState.defaults,
    this.focusNode,
    this.keyboardType,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final ValueChanged<String>? onChanged;
  final bool obscureText;
  final UiState state;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;

  static String sanitize(String raw) {
    return raw.replaceAll(RegExp(r'[\u0000-\u001F\u007F]'), '').trimLeft();
  }

  @override
  Widget build(BuildContext context) {
    final chrome = ControlChrome.resolve(
      context,
      state: state,
      role: ControlRole.textField,
    );
    final brand = context.brandColors;
    final enabled = chrome.interactive && state != UiState.loading;

    final field = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: chrome.foreground,
                ),
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
        Semantics(
          textField: true,
          label: label,
          obscured: obscureText,
          enabled: enabled,
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            enabled: enabled,
            obscureText: obscureText,
            keyboardType: keyboardType,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: chrome.foreground,
                ),
            cursorColor: brand.primary,
            onChanged: onChanged == null
                ? null
                : (value) => onChanged!(sanitize(value)),
            decoration: InputDecoration(
              isDense: true,
              hintText: hint,
              hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: brand.muted,
                  ),
              filled: true,
              fillColor: chrome.fill,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              prefixIcon: chrome.leadingIcon != null || chrome.showProgress
                  ? Padding(
                      padding: const EdgeInsets.only(left: AppSpacing.sm),
                      child: ControlStatusCue(chrome: chrome, compact: true),
                    )
                  : null,
              prefixIconConstraints: const BoxConstraints(
                minWidth: AppSpacing.xl,
                minHeight: AppSpacing.lg,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                borderSide: BorderSide(color: chrome.border),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                borderSide: BorderSide(color: chrome.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                borderSide: BorderSide(
                  color: brand.primary,
                  width: FocusStyles.ringWidth / 2,
                ),
              ),
            ),
          ),
        ),
        if (chrome.statusLabel != null) ...[
          const SizedBox(height: AppSpacing.xxs),
          Text(
            chrome.statusLabel!,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: chrome.foreground,
                ),
          ),
        ],
      ],
    );

    if (state == UiState.defaults) {
      return field;
    }

    // Outer shell carries forced-state scale / focus glow / opacity without
    // double-painting the field fill (cues stay on the TextField itself).
    return ControlShell(
      chrome: ControlChrome(
        state: chrome.state,
        label: chrome.label,
        fill: Colors.transparent,
        foreground: chrome.foreground,
        border: chrome.border,
        opacity: chrome.opacity,
        scale: chrome.scale,
        interactive: chrome.interactive,
        showFocusGlow: chrome.showFocusGlow,
        showProgress: false,
        leadingIcon: null,
        statusLabel: null,
      ),
      borderRadius: AppRadius.sm,
      padding: const EdgeInsets.all(AppSpacing.xs),
      child: field,
    );
  }
}
