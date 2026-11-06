import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/theme/theme.dart';
import 'package:mi_iptv/core/widgets/status_badge.dart';

void main() {
  group('Iconography DSN-019', () {
    test('locks every IconRole to a unique catalog entry', () {
      expect(Iconography.roles, IconRole.values);
      expect(Iconography.all, hasLength(IconRole.values.length));
      final roles = Iconography.all.map((e) => e.role).toSet();
      expect(roles, IconRole.values.toSet());
    });

    test('ambiguous roles require visible text labels', () {
      final required = Iconography.labelRequiredEntries.map((e) => e.role);
      expect(
        required,
        containsAll(<IconRole>[
          IconRole.sources,
          IconRole.devices,
          IconRole.phoneCompanion,
          IconRole.live,
          IconRole.activeSource,
          IconRole.synced,
          IconRole.connected,
          IconRole.weakNetwork,
          IconRole.empty,
          IconRole.offline,
          IconRole.warning,
        ]),
      );
      for (final entry in Iconography.labelRequiredEntries) {
        expect(entry.label, isNotEmpty, reason: '${entry.role}');
        expect(entry.labelRequired, isTrue);
      }
    });

    test('status indicator glyphs match StatusBadge / DSN-018 presets', () {
      expect(Iconography.live.icon, StatusBadgeSpec.live.icon);
      expect(Iconography.live.label, StatusBadgeSpec.live.label);
      expect(
        Iconography.activeSource.icon,
        StatusBadgeSpec.activeSource.icon,
      );
      expect(
        Iconography.activeSource.label,
        StatusBadgeSpec.activeSource.label,
      );
      expect(Iconography.synced.icon, StatusBadgeSpec.synced.icon);
      expect(Iconography.synced.label, StatusBadgeSpec.synced.label);
      expect(Iconography.connected.icon, StatusBadgeSpec.connected.icon);
      expect(Iconography.connected.label, StatusBadgeSpec.connected.label);
      expect(Iconography.weakNetwork.icon, StatusBadgeSpec.weakNetwork.icon);
      expect(Iconography.weakNetwork.label, StatusBadgeSpec.weakNetwork.label);
    });

    test('clear metaphors may omit visible labels', () {
      expect(Iconography.play.labelRequired, isFalse);
      expect(Iconography.search.labelRequired, isFalse);
      expect(Iconography.settings.labelRequired, isFalse);
      expect(Iconography.error.labelRequired, isFalse);
    });
  });

  test('DSN-019 markdown guide exists', () {
    expect(File('docs/design/iconography.md').existsSync(), isTrue);
  });
}
