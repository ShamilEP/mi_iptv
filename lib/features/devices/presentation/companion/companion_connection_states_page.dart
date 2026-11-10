import 'package:flutter/material.dart';

import '../../../../core/accessibility/companion_accessibility.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/brand_lockup.dart';
import 'companion_connection_notice.dart';
import 'companion_connection_state.dart';

/// Gallery of companion connection and notification states (DSN-053).
///
/// Light-theme shell listing Connected, Disconnected, Pairing error, TV offline,
/// and No network. Does not call pairing or connectivity APIs.
class CompanionConnectionStatesPage extends StatelessWidget {
  const CompanionConnectionStatesPage({
    super.key,
    this.onNoticeAction,
  });

  /// Fired with the notice state when its action is pressed.
  final ValueChanged<CompanionConnectionState>? onNoticeAction;

  static const String title = 'Connection states';
  static const String body =
      'Statuses the companion can show while linking to a TV.';

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final textTheme = Theme.of(context).textTheme;

    return CompanionAccessibleScope(
      child: Scaffold(
        backgroundColor: brand.cloud,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.insetPageCompanion),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BrandLockup(
                  markHeight: AppSpacing.xl,
                  tone: BrandMarkTone.companion,
                ),
                const SizedBox(height: AppSpacing.md),
                Expanded(
                  child: ListView(
                    children: [
                      Text(
                        title,
                        style: textTheme.headlineMedium?.copyWith(
                          color: brand.ink,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        body,
                        style: textTheme.bodyLarge?.copyWith(color: brand.muted),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      for (final spec in CompanionConnectionNoticeSpec.all) ...[
                        CompanionConnectionNotice(
                          key: ValueKey<CompanionConnectionState>(spec.state),
                          spec: spec,
                          onAction: onNoticeAction == null
                              ? null
                              : () => onNoticeAction!(spec.state),
                        ),
                        const SizedBox(height: AppSpacing.md),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
