import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Brand roles that Material [ColorScheme] does not cover cleanly.
///
/// Resolve via [ThemeData.extensions] or [BuildContext] helpers so TV and
/// Companion surfaces share one API with flavor-correct accents.
@immutable
class MiBrandColors extends ThemeExtension<MiBrandColors> {
  const MiBrandColors({
    required this.ink,
    required this.surface,
    required this.panel,
    required this.border,
    required this.cloud,
    required this.mist,
    required this.primary,
    required this.live,
    required this.success,
    required this.warning,
    required this.error,
    required this.muted,
  });

  factory MiBrandColors.tv() {
    return const MiBrandColors(
      ink: AppColors.ink,
      surface: AppColors.surface,
      panel: AppColors.panel,
      border: AppColors.border,
      cloud: AppColors.cloud,
      mist: AppColors.mist,
      primary: AppColors.signal,
      live: AppColors.ember,
      success: AppColors.success,
      warning: AppColors.warning,
      error: AppColors.error,
      muted: AppColors.mist,
    );
  }

  factory MiBrandColors.companion() {
    return const MiBrandColors(
      ink: AppColors.ink,
      surface: AppColors.surface,
      panel: AppColors.panel,
      border: AppColors.border,
      cloud: AppColors.cloud,
      mist: AppColors.mist,
      primary: AppColors.companionPrimary,
      live: AppColors.companionLive,
      success: AppColors.success,
      warning: AppColors.warning,
      error: AppColors.error,
      muted: AppColors.companionMuted,
    );
  }

  final Color ink;
  final Color surface;
  final Color panel;
  final Color border;
  final Color cloud;
  final Color mist;
  final Color primary;
  final Color live;
  final Color success;
  final Color warning;
  final Color error;
  final Color muted;

  @override
  MiBrandColors copyWith({
    Color? ink,
    Color? surface,
    Color? panel,
    Color? border,
    Color? cloud,
    Color? mist,
    Color? primary,
    Color? live,
    Color? success,
    Color? warning,
    Color? error,
    Color? muted,
  }) {
    return MiBrandColors(
      ink: ink ?? this.ink,
      surface: surface ?? this.surface,
      panel: panel ?? this.panel,
      border: border ?? this.border,
      cloud: cloud ?? this.cloud,
      mist: mist ?? this.mist,
      primary: primary ?? this.primary,
      live: live ?? this.live,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      muted: muted ?? this.muted,
    );
  }

  @override
  MiBrandColors lerp(ThemeExtension<MiBrandColors>? other, double t) {
    if (other is! MiBrandColors) {
      return this;
    }
    return MiBrandColors(
      ink: Color.lerp(ink, other.ink, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      panel: Color.lerp(panel, other.panel, t)!,
      border: Color.lerp(border, other.border, t)!,
      cloud: Color.lerp(cloud, other.cloud, t)!,
      mist: Color.lerp(mist, other.mist, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      live: Color.lerp(live, other.live, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
    );
  }
}
