import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/control_chrome.dart';
import '../../../../core/widgets/focusable_surface.dart';
import '../../../../core/widgets/mi_button.dart';
import '../../../../core/widgets/mi_chip.dart';
import 'tv_search_copy.dart';

/// Suggestion chips for partial / typo-tolerant search (DSN-065).
class TvSearchSuggestionChips extends StatelessWidget {
  const TvSearchSuggestionChips({
    super.key,
    required this.suggestions,
    required this.onSelected,
  });

  final List<String> suggestions;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) return const SizedBox.shrink();

    final brand = context.brandColors;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          TvSearchCopy.suggestionsLabel,
          style: textTheme.titleSmall?.copyWith(color: brand.mist),
        ),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            for (final suggestion in suggestions)
              MiChip(
                key: ValueKey<String>('search-suggestion-$suggestion'),
                label: suggestion,
                onPressed: () => onSelected(suggestion),
              ),
          ],
        ),
      ],
    );
  }
}

/// “Did you mean …” recovery when the query looks like a typo (DSN-065).
class TvSearchDidYouMean extends StatelessWidget {
  const TvSearchDidYouMean({
    super.key,
    required this.suggestion,
    required this.onApply,
  });

  final String suggestion;
  final ValueChanged<String> onApply;

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final textTheme = Theme.of(context).textTheme;

    return FocusableSurface(
      key: const ValueKey<String>('search-did-you-mean'),
      kind: FocusControlKind.card,
      fill: brand.panel,
      borderRadius: AppRadius.md,
      padding: const EdgeInsets.all(AppSpacing.md),
      onPressed: () => onApply(suggestion),
      child: Row(
        children: [
          Icon(
            Icons.spellcheck,
            color: brand.primary,
            size: AppSpacing.lg,
            semanticLabel: TvSearchCopy.didYouMeanPrefix,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: textTheme.bodyLarge?.copyWith(color: brand.cloud),
                children: <InlineSpan>[
                  const TextSpan(text: '${TvSearchCopy.didYouMeanPrefix} '),
                  TextSpan(
                    text: suggestion,
                    style: textTheme.titleMedium?.copyWith(
                      color: brand.primary,
                    ),
                  ),
                  const TextSpan(text: '?'),
                ],
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          MiButton(
            key: const ValueKey<String>('search-did-you-mean-apply'),
            label: TvSearchCopy.applySuggestionLabel,
            emphasis: ControlEmphasis.secondary,
            onPressed: () => onApply(suggestion),
          ),
        ],
      ),
    );
  }
}
