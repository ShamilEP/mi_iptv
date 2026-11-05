import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/theme/theme.dart';

void main() {
  group('SemanticColorUsage DSN-007', () {
    test('locks five status roles from Color.pdf / tracker DoD', () {
      expect(SemanticColorUsage.roles, hasLength(5));
      expect(
        SemanticColorUsage.all.map((r) => r.summary).toList(),
        <String>[
          'Signal = primary / actions / progress',
          'Ember = LIVE, alerts, send-to-TV',
          'Success = synced / connected',
          'Warning = weak network',
          'Error = stream failed',
        ],
      );
    });

    test('maps TV and Companion tokens correctly', () {
      final primary = SemanticColorUsage.of(SemanticColorRole.primaryAction);
      expect(primary.tvColor, AppColors.signal);
      expect(primary.companionColor, AppColors.companionPrimary);

      final live = SemanticColorUsage.of(SemanticColorRole.liveAlert);
      expect(live.tvColor, AppColors.ember);
      expect(live.companionColor, AppColors.companionLive);

      final synced = SemanticColorUsage.of(SemanticColorRole.syncedConnected);
      expect(synced.tvColor, AppColors.success);
      expect(synced.companionColor, AppColors.success);

      final weak = SemanticColorUsage.of(SemanticColorRole.weakNetwork);
      expect(weak.tvColor, AppColors.warning);

      final failed = SemanticColorUsage.of(SemanticColorRole.streamFailed);
      expect(failed.tvColor, AppColors.error);
    });

    test('resolve flips Signal/Ember for companion surfaces', () {
      expect(
        SemanticColorUsage.resolve(
          SemanticColorRole.primaryAction,
          companion: false,
        ),
        AppColors.signal,
      );
      expect(
        SemanticColorUsage.resolve(
          SemanticColorRole.primaryAction,
          companion: true,
        ),
        AppColors.companionPrimary,
      );
      expect(
        SemanticColorUsage.resolve(
          SemanticColorRole.liveAlert,
          companion: true,
        ),
        AppColors.companionLive,
      );
    });

    test('every rule lists allowed and forbidden uses', () {
      for (final rule in SemanticColorUsage.all) {
        expect(rule.allowedUses, isNotEmpty, reason: rule.summary);
        expect(rule.forbiddenUses, isNotEmpty, reason: rule.summary);
      }
    });
  });

  test('DSN-007 markdown guide exists', () {
    final file = File('docs/design/semantic_color_usage.md');
    expect(file.existsSync(), isTrue);
    final text = file.readAsStringSync();
    expect(text, contains('Signal'));
    expect(text, contains('Ember'));
    expect(text, contains('Success'));
    expect(text, contains('Warning'));
    expect(text, contains('Error'));
  });
}
