import 'package:flutter/material.dart';

import '../../../../core/l10n/app_locale.dart';
import '../../../../core/l10n/app_locale_scope.dart';
import '../../../../core/l10n/app_string_key.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/brand_lockup.dart';
import '../../../../core/widgets/control_chrome.dart';
import '../../../../core/widgets/mi_button.dart';

/// Companion language picker + locale format preview (CMP-008 / NFR-012).
class CompanionLanguagePage extends StatelessWidget {
  const CompanionLanguagePage({
    super.key,
    this.sampleDate,
    this.sampleNumber = 1234.56,
  });

  final DateTime? sampleDate;
  final num sampleNumber;

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final textTheme = Theme.of(context).textTheme;
    final controller = AppLocaleScope.controllerOf(context);
    final locale = controller.locale;
    final date = sampleDate ?? DateTime(2026, 11, 13);

    return Scaffold(
      backgroundColor: brand.cloud,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.insetPageCompanion),
          child: ListView(
            children: [
              const BrandLockup(
                markHeight: AppSpacing.xl,
                tone: BrandMarkTone.companion,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                AppLocaleScope.stringOf(context, AppStringKey.languageTitle),
                style: textTheme.headlineMedium?.copyWith(color: brand.ink),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                AppLocaleScope.stringOf(context, AppStringKey.languageBody),
                style: textTheme.bodyLarge?.copyWith(color: brand.muted),
              ),
              const SizedBox(height: AppSpacing.lg),
              for (final option in AppLocale.supported) ...[
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: MiButton(
                    label: option.displayName,
                    emphasis: option == locale
                        ? ControlEmphasis.primary
                        : ControlEmphasis.secondary,
                    onPressed: () => controller.setLocale(option),
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              Text(
                AppLocaleScope.stringOf(
                  context,
                  AppStringKey.formatDateSampleLabel,
                ),
                style: textTheme.titleLarge?.copyWith(color: brand.ink),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                AppLocaleScope.formatDate(context, date),
                key: const ValueKey<String>('locale-date-sample'),
                style: textTheme.bodyLarge?.copyWith(color: brand.ink),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                AppLocaleScope.stringOf(
                  context,
                  AppStringKey.formatNumberSampleLabel,
                ),
                style: textTheme.titleLarge?.copyWith(color: brand.ink),
              ),
              const SizedBox(height: AppSpacing.xxs),
              Text(
                AppLocaleScope.formatDecimal(context, sampleNumber),
                key: const ValueKey<String>('locale-number-sample'),
                style: textTheme.bodyLarge?.copyWith(color: brand.ink),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
