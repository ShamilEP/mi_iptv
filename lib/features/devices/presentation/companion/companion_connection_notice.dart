import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/control_chrome.dart';
import '../../../../core/widgets/mi_button.dart';
import 'companion_connection_state.dart';

/// Companion light-theme connection / notification banner (DSN-053).
///
/// Accent always ships with icon + title (DSN-002 / DSN-010). Design shell only:
/// actions are host callbacks and do not call pairing or network APIs.
class CompanionConnectionNotice extends StatelessWidget {
  const CompanionConnectionNotice({
    super.key,
    required this.spec,
    this.onAction,
  });

  factory CompanionConnectionNotice.forState(
    CompanionConnectionState state, {
    Key? key,
    VoidCallback? onAction,
  }) {
    return CompanionConnectionNotice(
      key: key,
      spec: CompanionConnectionNoticeSpec.of(state),
      onAction: onAction,
    );
  }

  final CompanionConnectionNoticeSpec spec;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final textTheme = Theme.of(context).textTheme;
    final accent = SemanticColorUsage.resolve(
      spec.colorRole,
      companion: true,
    );

    return Semantics(
      container: true,
      liveRegion: true,
      label: '${spec.title}. ${spec.message}',
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: brand.cloud,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: accent.withValues(alpha: 0.65)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.insetCard),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Iconography.of(spec.iconRole).icon,
                    color: accent,
                    size: AppSpacing.lg,
                    semanticLabel: spec.title,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          spec.title,
                          style: textTheme.titleLarge?.copyWith(
                            color: brand.ink,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          spec.message,
                          style: textTheme.bodyLarge?.copyWith(
                            color: brand.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (onAction != null) ...[
                const SizedBox(height: AppSpacing.md),
                MiButton(
                  label: spec.actionLabel,
                  onPressed: onAction,
                  emphasis: ControlEmphasis.primary,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
