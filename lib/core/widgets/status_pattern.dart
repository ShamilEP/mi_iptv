import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'control_chrome.dart';
import 'mi_button.dart';
import 'status_pattern_copy.dart';
import 'ui_state.dart';
import 'ui_state_catalog.dart';

/// Shared empty / error / offline panel with actionable next step (DSN-017).
///
/// Always pairs hue with icon + copy (DSN-002 / DSN-010).
class StatusPattern extends StatelessWidget {
  const StatusPattern({
    super.key,
    required this.state,
    required this.title,
    required this.message,
    required this.actionLabel,
    this.onAction,
    this.icon,
  }) : assert(
         state == UiState.empty ||
             state == UiState.error ||
             state == UiState.offline,
         'StatusPattern only supports empty, error, and offline',
       );

  factory StatusPattern.fromCopy({
    Key? key,
    required UiState state,
    required StatusPatternCopy copy,
    VoidCallback? onAction,
    IconData? icon,
  }) {
    return StatusPattern(
      key: key,
      state: state,
      title: copy.title,
      message: copy.message,
      actionLabel: copy.actionLabel,
      onAction: onAction,
      icon: icon,
    );
  }

  final UiState state;
  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback? onAction;
  final IconData? icon;

  static IconData defaultIconFor(UiState state) {
    switch (state) {
      case UiState.empty:
        return Icons.inbox_outlined;
      case UiState.error:
        return Icons.error_outline;
      case UiState.offline:
        return Icons.wifi_off_outlined;
      default:
        return Icons.info_outline;
    }
  }

  static Color accentFor(BuildContext context, UiState state) {
    final brand = context.brandColors;
    switch (state) {
      case UiState.empty:
        return brand.muted;
      case UiState.error:
        return brand.error;
      case UiState.offline:
        return brand.warning;
      default:
        return brand.muted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final textTheme = Theme.of(context).textTheme;
    final companion = Theme.of(context).brightness == Brightness.light;
    final titleColor = companion ? brand.ink : brand.cloud;
    final messageColor = companion ? brand.muted : brand.mist;
    final accent = accentFor(context, state);
    final catalog = UiStateCatalog.of(state);
    final resolvedIcon = icon ?? defaultIconFor(state);

    return Semantics(
      container: true,
      label: '$title. ${catalog.label}. $message',
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              resolvedIcon,
              size: AppSpacing.xxl,
              color: accent,
              semanticLabel: catalog.label,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              catalog.label,
              style: textTheme.labelLarge?.copyWith(color: accent),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              title,
              textAlign: TextAlign.center,
              style: textTheme.headlineMedium?.copyWith(color: titleColor),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge?.copyWith(color: messageColor),
            ),
            if (onAction != null) ...[
              const SizedBox(height: AppSpacing.lg),
              MiButton(
                label: actionLabel,
                onPressed: onAction,
                emphasis: ControlEmphasis.primary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Empty-state pattern (DSN-017).
class EmptyPattern extends StatelessWidget {
  const EmptyPattern({
    super.key,
    this.copy = StatusPatternCopy.genericEmpty,
    this.onAction,
    this.icon,
  }) : _favoritesPreset = false;

  /// Favorites empty preset from tracker DoD (`No hay favoritos`).
  const EmptyPattern.favorites({super.key, this.onAction, this.icon})
    : copy = StatusPatternCopy.favoritesEmpty,
      _favoritesPreset = true;

  final StatusPatternCopy copy;
  final VoidCallback? onAction;
  final IconData? icon;
  final bool _favoritesPreset;

  @override
  Widget build(BuildContext context) {
    return StatusPattern.fromCopy(
      state: UiState.empty,
      copy: copy,
      onAction: onAction,
      icon:
          icon ??
          (_favoritesPreset ? Icons.favorite_border : Icons.inbox_outlined),
    );
  }
}

/// Error-state pattern with retry next step (DSN-017).
class ErrorPattern extends StatelessWidget {
  const ErrorPattern({
    super.key,
    this.copy = StatusPatternCopy.genericError,
    this.onAction,
    this.icon,
  });

  final StatusPatternCopy copy;
  final VoidCallback? onAction;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return StatusPattern.fromCopy(
      state: UiState.error,
      copy: copy,
      onAction: onAction,
      icon: icon,
    );
  }
}

/// Offline-state pattern with reconnect next step (DSN-017).
class OfflinePattern extends StatelessWidget {
  const OfflinePattern({
    super.key,
    this.copy = StatusPatternCopy.genericOffline,
    this.onAction,
    this.icon,
  });

  final StatusPatternCopy copy;
  final VoidCallback? onAction;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return StatusPattern.fromCopy(
      state: UiState.offline,
      copy: copy,
      onAction: onAction,
      icon: icon,
    );
  }
}
