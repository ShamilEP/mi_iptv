import 'package:flutter/material.dart';

import '../theme/theme.dart';
import 'companion_platform.dart';
import 'companion_platform_conventions.dart';

/// Platform-aware leave control for companion pushed screens (DSN-054).
///
/// **iOS** — leading chevron + Back label (pairs with edge-swipe).
/// **Android** — empty chrome; system Back / predictive back owns leave, so no
/// invented leading chevron is shown.
class CompanionPlatformBackAffordance extends StatelessWidget {
  const CompanionPlatformBackAffordance({
    super.key,
    required this.onBack,
    this.platform,
  });

  final VoidCallback onBack;

  /// Override host platform for galleries and tests.
  final CompanionPlatform? platform;

  @override
  Widget build(BuildContext context) {
    final conventions = CompanionPlatformConventions.of(platform);
    final brand = context.brandColors;
    final textTheme = Theme.of(context).textTheme;

    if (conventions.platform == CompanionPlatform.android) {
      return const SizedBox.shrink(
        key: ValueKey<String>('companion-back-android'),
      );
    }

    return Semantics(
      button: true,
      label: conventions.backAffordanceLabel,
      child: InkWell(
        key: const ValueKey<String>('companion-back-ios'),
        onTap: onBack,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxs,
            vertical: AppSpacing.xs,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.arrow_back_ios_new,
                size: AppSpacing.md,
                color: brand.primary,
                semanticLabel: conventions.backAffordanceLabel,
              ),
              const SizedBox(width: AppSpacing.xxs),
              Text(
                conventions.backAffordanceLabel,
                style: textTheme.labelLarge?.copyWith(color: brand.primary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
