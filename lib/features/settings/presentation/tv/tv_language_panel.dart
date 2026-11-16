import 'package:flutter/material.dart';

import '../../../../core/l10n/app_locale.dart';
import '../../../../core/l10n/app_locale_scope.dart';
import '../../../../core/l10n/app_string_key.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/control_chrome.dart';
import '../../../../core/widgets/mi_button.dart';
import '../../../../core/widgets/mi_list_row.dart';
import 'tv_settings_copy.dart';
import 'tv_settings_models.dart';

/// TV language picker + locale format preview (TV-014 / NFR-012).
class TvLanguagePanel extends StatelessWidget {
  const TvLanguagePanel({
    super.key,
    this.extraValues = const <TvSettingsValue>[],
    this.sampleDate,
    this.sampleNumber = 1234.56,
  });

  /// Non-language demo fields (audio preference, subtitles, …).
  final List<TvSettingsValue> extraValues;
  final DateTime? sampleDate;
  final num sampleNumber;

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final textTheme = Theme.of(context).textTheme;
    final controller = AppLocaleScope.controllerOf(context);
    final locale = controller.locale;
    final date = sampleDate ?? DateTime(2026, 11, 13);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          TvSettingsCopy.forLocale(locale, AppStringKey.settingsLanguage),
          style: textTheme.titleLarge?.copyWith(color: brand.cloud),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          TvSettingsCopy.forLocale(locale, AppStringKey.languageBodyTv),
          style: textTheme.bodyLarge?.copyWith(color: brand.mist),
        ),
        const SizedBox(height: AppSpacing.md),
        for (final option in AppLocale.supported) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: MiButton(
              key: ValueKey<String>('tv-locale-${option.languageTag}'),
              label: option.displayName,
              emphasis: option == locale
                  ? ControlEmphasis.primary
                  : ControlEmphasis.secondary,
              onPressed: () => controller.setLocale(option),
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.md),
        Text(
          AppLocaleScope.stringOf(context, AppStringKey.formatDateSampleLabel),
          style: textTheme.titleLarge?.copyWith(color: brand.cloud),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          AppLocaleScope.formatDate(context, date),
          key: const ValueKey<String>('tv-locale-date-sample'),
          style: textTheme.bodyLarge?.copyWith(color: brand.cloud),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          AppLocaleScope.stringOf(
            context,
            AppStringKey.formatNumberSampleLabel,
          ),
          style: textTheme.titleLarge?.copyWith(color: brand.cloud),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          AppLocaleScope.formatDecimal(context, sampleNumber),
          key: const ValueKey<String>('tv-locale-number-sample'),
          style: textTheme.bodyLarge?.copyWith(color: brand.cloud),
        ),
        if (extraValues.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          Text(
            TvSettingsCopy.forLocale(
              locale,
              AppStringKey.settingsCurrentValues,
            ),
            style: textTheme.bodyLarge?.copyWith(color: brand.mist),
          ),
          const SizedBox(height: AppSpacing.md),
          for (final item in extraValues) ...[
            MiListRow(
              key: ValueKey<String>('settings-value-${item.label}'),
              title: item.label,
              subtitle: item.value,
            ),
            const SizedBox(height: AppSpacing.xs),
          ],
        ],
      ],
    );
  }
}
