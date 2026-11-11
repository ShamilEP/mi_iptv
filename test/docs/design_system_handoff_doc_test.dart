import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/theme/app_colors.dart';
import 'package:mi_iptv/core/theme/app_motion.dart';
import 'package:mi_iptv/core/theme/app_overscan.dart';
import 'package:mi_iptv/core/theme/app_radius.dart';
import 'package:mi_iptv/core/theme/app_spacing.dart';
import 'package:mi_iptv/core/theme/app_typography.dart';
import 'package:mi_iptv/core/theme/brand_assets.dart';
import 'package:mi_iptv/core/theme/focus_styles.dart';
import 'package:mi_iptv/core/widgets/content_card_metrics.dart';

/// Locks DSN-008 design system handoff + token export.
void main() {
  test('DSN-008 handoff doc covers library, naming, tokens, redlines', () {
    final file = File('docs/design/design_system_handoff.md');
    expect(file.existsSync(), isTrue);

    final text = file.readAsStringSync();
    expect(text, contains('DSN-008'));
    expect(text, contains('Naming conventions'));
    expect(text, contains('Tokens as code'));
    expect(text, contains('Shared component library'));
    expect(text, contains('Redlines'));
    expect(text, contains('brand_tokens.json'));
    expect(text, contains('FocusableSurface'));
    expect(text, contains('AppColors'));
    expect(text, contains('AppOverscan'));
    expect(text, contains('no divergent Figma'));
  });

  test('DSN-008 brand_tokens.json mirrors Dart theme tokens', () {
    final file = File('docs/design/brand_tokens.json');
    expect(file.existsSync(), isTrue);

    final json =
        jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
    expect(json['meta'], isA<Map<String, dynamic>>());
    expect((json['meta'] as Map)['task'], 'DSN-008');

    final color = json['color'] as Map<String, dynamic>;
    expect(color['ink'], _hex(AppColors.ink));
    expect(color['surface'], _hex(AppColors.surface));
    expect(color['panel'], _hex(AppColors.panel));
    expect(color['border'], _hex(AppColors.border));
    expect(color['cloud'], _hex(AppColors.cloud));
    expect(color['mist'], _hex(AppColors.mist));
    expect(color['signal'], _hex(AppColors.signal));
    expect(color['ember'], _hex(AppColors.ember));
    expect(color['success'], _hex(AppColors.success));
    expect(color['warning'], _hex(AppColors.warning));
    expect(color['error'], _hex(AppColors.error));
    expect(color['companionPrimary'], _hex(AppColors.companionPrimary));
    expect(color['companionLive'], _hex(AppColors.companionLive));
    expect(color['companionMuted'], _hex(AppColors.companionMuted));

    final typography = json['typography'] as Map<String, dynamic>;
    final families = typography['families'] as Map<String, dynamic>;
    expect(families['display'], AppTypography.displayFamily);
    expect(families['body'], AppTypography.bodyFamily);
    expect(families['data'], AppTypography.dataFamily);

    final tv = typography['tv'] as Map<String, dynamic>;
    expect((tv['display'] as Map)['size'], AppTypography.tvDisplaySize);
    expect((tv['headline'] as Map)['size'], AppTypography.tvHeadlineSize);
    expect((tv['title'] as Map)['size'], AppTypography.tvTitleSize);
    expect((tv['body'] as Map)['size'], AppTypography.tvBodySize);
    expect((tv['label'] as Map)['size'], AppTypography.tvLabelSize);
    expect((tv['data'] as Map)['size'], AppTypography.tvDataSize);

    final companion = typography['companion'] as Map<String, dynamic>;
    expect(
      (companion['display'] as Map)['size'],
      AppTypography.companionDisplaySize,
    );
    expect(
      (companion['headline'] as Map)['size'],
      AppTypography.companionHeadlineSize,
    );
    expect(
      (companion['title'] as Map)['size'],
      AppTypography.companionTitleSize,
    );
    expect((companion['body'] as Map)['size'], AppTypography.companionBodySize);
    expect(
      (companion['label'] as Map)['size'],
      AppTypography.companionLabelSize,
    );
    expect((companion['data'] as Map)['size'], AppTypography.companionDataSize);

    final spacing = json['spacing'] as Map<String, dynamic>;
    expect(spacing['xxs'], AppSpacing.xxs);
    expect(spacing['xs'], AppSpacing.xs);
    expect(spacing['sm'], AppSpacing.sm);
    expect(spacing['md'], AppSpacing.md);
    expect(spacing['lg'], AppSpacing.lg);
    expect(spacing['xl'], AppSpacing.xl);
    expect(spacing['xxl'], AppSpacing.xxl);
    expect(spacing['xxxl'], AppSpacing.xxxl);
    expect(spacing['insetPageTv'], AppSpacing.insetPageTv);
    expect(spacing['insetPageCompanion'], AppSpacing.insetPageCompanion);

    final grid = json['grid'] as Map<String, dynamic>;
    expect(grid['gutter'], AppGrid.gutter);
    expect(grid['rowGap'], AppGrid.rowGap);
    expect(grid['railGap'], AppGrid.railGap);

    expect((json['overscan'] as Map)['inset'], AppOverscan.inset);

    final radius = json['radius'] as Map<String, dynamic>;
    expect(radius['xs'], AppRadius.xs);
    expect(radius['sm'], AppRadius.sm);
    expect(radius['md'], AppRadius.md);
    expect(radius['lg'], AppRadius.lg);
    expect(radius['full'], AppRadius.full);

    final motion = json['motion'] as Map<String, dynamic>;
    expect(motion['fastMs'], AppMotion.fast.inMilliseconds);
    expect(motion['normalMs'], AppMotion.normal.inMilliseconds);
    expect(motion['slowMs'], AppMotion.slow.inMilliseconds);
    expect(
      motion['channelInfoAutoHideMs'],
      AppMotion.channelInfoAutoHide.inMilliseconds,
    );
    expect(
      motion['playerControlsAutoHideMs'],
      AppMotion.playerControlsAutoHide.inMilliseconds,
    );
    expect(motion['splashHoldMs'], AppMotion.splashHold.inMilliseconds);

    final focus = json['focus'] as Map<String, dynamic>;
    expect(focus['scale'], FocusStyles.scale);
    expect(focus['ringWidth'], FocusStyles.ringWidth);
    expect(focus['ringColor'], _hex(FocusStyles.ringColor));
    expect(focus['glowColor'], _hex(FocusStyles.glowColor));
    expect(focus['glowSpread'], FocusStyles.glowSpread);
    expect(focus['glowAlpha'], FocusStyles.glowAlpha);

    final brand = json['brand'] as Map<String, dynamic>;
    expect(brand['viewBoxWidth'], BrandAssets.viewBoxWidth);
    expect(brand['viewBoxHeight'], BrandAssets.viewBoxHeight);
    expect(brand['strokeWidth'], BrandAssets.strokeWidth);
    expect(brand['liveDotRadius'], BrandAssets.liveDotRadius);
    expect(brand['clearSpaceUnit'], BrandAssets.clearSpaceUnit);
    expect(brand['minMarkSize'], BrandAssets.minMarkSize);
    expect(brand['wordmarkText'], BrandAssets.wordmarkText);
    expect(brand['wordmarkTrackingEm'], BrandAssets.wordmarkTrackingEm);

    final cards = json['contentCard'] as Map<String, dynamic>;
    expect((cards['poster'] as Map)['width'], ContentCardMetrics.posterWidth);
    expect(
      (cards['landscape'] as Map)['width'],
      ContentCardMetrics.landscapeWidth,
    );
    expect(
      (cards['channelTile'] as Map)['width'],
      ContentCardMetrics.channelTileWidth,
    );
    expect(
      (cards['continueWatching'] as Map)['width'],
      ContentCardMetrics.continueWatchingWidth,
    );
    expect(cards['progressTrackHeight'], ContentCardMetrics.progressTrackHeight);
  });
}

String _hex(Color color) {
  final value = color.toARGB32() & 0xFFFFFF;
  return '#${value.toRadixString(16).padLeft(6, '0').toUpperCase()}';
}
