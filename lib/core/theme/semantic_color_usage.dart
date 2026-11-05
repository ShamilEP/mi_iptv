import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Semantic accent roles from Brand Theme / Color.pdf (DSN-007).
///
/// Structural tokens (ink, surface, panel, border, cloud, mist) are not listed
/// here — see [AppColors]. Status accents must always ship with a non-color cue
/// (DSN-002 / DSN-010).
enum SemanticColorRole {
  /// Primary actions, CTAs, progress (Signal on TV; companionPrimary on light).
  primaryAction,

  /// LIVE badge, alerts, send-to-TV (Ember on TV; companionLive on light).
  liveAlert,

  /// Synced / connected affirmation (Success).
  syncedConnected,

  /// Weak network / degraded connectivity (Warning).
  weakNetwork,

  /// Stream / load failure (Error).
  streamFailed,
}

/// One locked usage rule for a [SemanticColorRole].
@immutable
class SemanticColorRule {
  const SemanticColorRule({
    required this.role,
    required this.summary,
    required this.tvToken,
    required this.tvColor,
    required this.companionToken,
    required this.companionColor,
    required this.allowedUses,
    required this.forbiddenUses,
  });

  final SemanticColorRole role;

  /// Short product sentence (matches tracker DoD wording).
  final String summary;

  final String tvToken;
  final Color tvColor;
  final String companionToken;
  final Color companionColor;
  final List<String> allowedUses;
  final List<String> forbiddenUses;
}

/// Executable semantic color usage guide (DSN-007).
abstract final class SemanticColorUsage {
  static const List<SemanticColorRole> roles = SemanticColorRole.values;

  static SemanticColorRule of(SemanticColorRole role) {
    switch (role) {
      case SemanticColorRole.primaryAction:
        return const SemanticColorRule(
          role: SemanticColorRole.primaryAction,
          summary: 'Signal = primary / actions / progress',
          tvToken: 'signal',
          tvColor: AppColors.signal,
          companionToken: 'companionPrimary',
          companionColor: AppColors.companionPrimary,
          allowedUses: <String>[
            'Primary and secondary CTAs (filled / emphasis)',
            'Progress tracks and determinate bars',
            'Focus outer glow accent (with Cloud ring)',
            'Selected / playing chrome accents',
          ],
          forbiddenUses: <String>[
            'LIVE badge or send-to-TV (use Ember / companionLive)',
            'Body text on Cloud (fails WCAG AA)',
            'Hue-only status without icon or label',
          ],
        );
      case SemanticColorRole.liveAlert:
        return const SemanticColorRule(
          role: SemanticColorRole.liveAlert,
          summary: 'Ember = LIVE, alerts, send-to-TV',
          tvToken: 'ember',
          tvColor: AppColors.ember,
          companionToken: 'companionLive',
          companionColor: AppColors.companionLive,
          allowedUses: <String>[
            'LIVE pill / badge (with LIVE text or icon)',
            'Send-to-TV affordances',
            'Attention alerts that are not stream failures',
          ],
          forbiddenUses: <String>[
            'Primary CTA fill (use Signal / companionPrimary)',
            'Stream-failed error chrome (use Error)',
            'Body text on Cloud (fails WCAG AA)',
          ],
        );
      case SemanticColorRole.syncedConnected:
        return const SemanticColorRule(
          role: SemanticColorRole.syncedConnected,
          summary: 'Success = synced / connected',
          tvToken: 'success',
          tvColor: AppColors.success,
          companionToken: 'success',
          companionColor: AppColors.success,
          allowedUses: <String>[
            'Device / account synced indicators',
            'Connected / online affirmation (with icon or label)',
          ],
          forbiddenUses: <String>[
            'Weak-network warning (use Warning)',
            'Primary CTA (use Signal / companionPrimary)',
            'Body text on Cloud (fails WCAG AA)',
          ],
        );
      case SemanticColorRole.weakNetwork:
        return const SemanticColorRule(
          role: SemanticColorRole.weakNetwork,
          summary: 'Warning = weak network',
          tvToken: 'warning',
          tvColor: AppColors.warning,
          companionToken: 'warning',
          companionColor: AppColors.warning,
          allowedUses: <String>[
            'Weak or unstable network banners',
            'Sync conflict caution chrome (with warning icon + copy)',
          ],
          forbiddenUses: <String>[
            'Stream failure (use Error)',
            'Successful sync (use Success)',
            'Body text on Cloud (fails WCAG AA)',
          ],
        );
      case SemanticColorRole.streamFailed:
        return const SemanticColorRule(
          role: SemanticColorRole.streamFailed,
          summary: 'Error = stream failed',
          tvToken: 'error',
          tvColor: AppColors.error,
          companionToken: 'error',
          companionColor: AppColors.error,
          allowedUses: <String>[
            'Stream / playback failure overlays',
            'Hard failure messages with retry',
          ],
          forbiddenUses: <String>[
            'LIVE badge (use Ember)',
            'Weak network only (use Warning)',
            'Body text on Cloud (fails WCAG AA)',
          ],
        );
    }
  }

  static List<SemanticColorRule> get all =>
      roles.map(of).toList(growable: false);

  /// TV vs Companion accent for [role] (structural tokens unchanged).
  static Color resolve(SemanticColorRole role, {required bool companion}) {
    final rule = of(role);
    return companion ? rule.companionColor : rule.tvColor;
  }
}
