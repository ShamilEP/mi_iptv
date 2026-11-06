import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Locked badge kinds for DSN-018 status indicators.
enum StatusBadgeKind {
  /// LIVE (Ember / companionLive).
  live,

  /// Active catalog / IPTV source (Signal / companionPrimary).
  activeSource,

  /// Device or account synced / connected (Success).
  syncedConnected,

  /// Weak or degraded network (Warning).
  weakNetwork,
}

/// Copy + icon + semantic role for a [StatusBadgeKind].
@immutable
class StatusBadgeSpec {
  const StatusBadgeSpec({
    required this.kind,
    required this.role,
    required this.label,
    required this.icon,
  });

  final StatusBadgeKind kind;
  final SemanticColorRole role;
  final String label;
  final IconData icon;

  static const StatusBadgeSpec live = StatusBadgeSpec(
    kind: StatusBadgeKind.live,
    role: SemanticColorRole.liveAlert,
    label: 'LIVE',
    icon: Icons.fiber_manual_record,
  );

  static const StatusBadgeSpec activeSource = StatusBadgeSpec(
    kind: StatusBadgeKind.activeSource,
    role: SemanticColorRole.primaryAction,
    label: 'Active source',
    icon: Icons.radio_button_checked,
  );

  static const StatusBadgeSpec synced = StatusBadgeSpec(
    kind: StatusBadgeKind.syncedConnected,
    role: SemanticColorRole.syncedConnected,
    label: 'Synced',
    icon: Icons.cloud_done_outlined,
  );

  static const StatusBadgeSpec connected = StatusBadgeSpec(
    kind: StatusBadgeKind.syncedConnected,
    role: SemanticColorRole.syncedConnected,
    label: 'Connected',
    icon: Icons.link,
  );

  static const StatusBadgeSpec weakNetwork = StatusBadgeSpec(
    kind: StatusBadgeKind.weakNetwork,
    role: SemanticColorRole.weakNetwork,
    label: 'Weak network',
    icon: Icons.wifi_1_bar,
  );

  static StatusBadgeSpec defaultsFor(StatusBadgeKind kind) {
    switch (kind) {
      case StatusBadgeKind.live:
        return live;
      case StatusBadgeKind.activeSource:
        return activeSource;
      case StatusBadgeKind.syncedConnected:
        return synced;
      case StatusBadgeKind.weakNetwork:
        return weakNetwork;
    }
  }
}

/// Compact status badge — accent always paired with icon + label (DSN-018).
///
/// Never use hue alone: both the icon and the text label are required cues.
class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.spec,
    this.label,
    this.icon,
  });

  const StatusBadge.live({
    super.key,
    this.label,
    this.icon,
  }) : spec = StatusBadgeSpec.live;

  const StatusBadge.activeSource({
    super.key,
    this.label,
    this.icon,
  }) : spec = StatusBadgeSpec.activeSource;

  const StatusBadge.synced({
    super.key,
    this.label,
    this.icon,
  }) : spec = StatusBadgeSpec.synced;

  const StatusBadge.connected({
    super.key,
    this.label,
    this.icon,
  }) : spec = StatusBadgeSpec.connected;

  const StatusBadge.weakNetwork({
    super.key,
    this.label,
    this.icon,
  }) : spec = StatusBadgeSpec.weakNetwork;

  final StatusBadgeSpec spec;

  /// Override locked default label; empty overrides are rejected at build.
  final String? label;
  final IconData? icon;

  String get effectiveLabel {
    final value = label ?? spec.label;
    assert(value.isNotEmpty, 'StatusBadge label must not be empty');
    return value;
  }

  IconData get effectiveIcon => icon ?? spec.icon;

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final companion = Theme.of(context).brightness == Brightness.light;
    final accent = SemanticColorUsage.resolve(
      spec.role,
      companion: companion,
    );
    final text = effectiveLabel;
    final glyph = effectiveIcon;

    return Semantics(
      label: text,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: brand.panel,
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: Border.all(color: accent.withValues(alpha: 0.55)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xxs,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                glyph,
                size: AppSpacing.md,
                color: accent,
                semanticLabel: text,
              ),
              const SizedBox(width: AppSpacing.xxs),
              Text(
                text,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: brand.cloud,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
