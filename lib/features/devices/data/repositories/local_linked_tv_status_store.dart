import 'dart:convert';

import '../../../../core/persistence/local_media_store.dart';
import '../../../settings/domain/entities/cached_setting.dart';
import '../../domain/entities/linked_tv_snapshot.dart';
import '../../domain/repositories/linked_tv_status_store.dart';

/// [LocalMediaStore] settings-backed linked TV status (CMP-006 / NFR-011).
///
/// Wire format is plain JSON — never pairing secrets or credentials.
final class LocalLinkedTvStatusStore implements LinkedTvStatusStore {
  LocalLinkedTvStatusStore(this._store);

  static const String settingKey = 'devices.linked_tv_status.v1';

  final LocalMediaStore _store;

  @override
  Future<LinkedTvSnapshot?> load() async {
    final row = await _store.loadSetting(settingKey);
    if (row == null || row.value.trim().isEmpty) return null;
    try {
      final map = jsonDecode(row.value);
      if (map is! Map) return null;
      final deviceId = map['deviceId']?.toString();
      final displayName = map['displayName']?.toString();
      final online = map['lastKnownOnline'];
      final updatedRaw = map['updatedAt']?.toString();
      if (deviceId == null ||
          deviceId.isEmpty ||
          displayName == null ||
          displayName.isEmpty ||
          updatedRaw == null) {
        return null;
      }
      final updatedAt = DateTime.tryParse(updatedRaw);
      if (updatedAt == null) return null;
      return LinkedTvSnapshot(
        deviceId: deviceId,
        displayName: displayName,
        lastKnownOnline: online == true,
        updatedAt: updatedAt.toUtc(),
      );
    } on FormatException {
      return null;
    }
  }

  @override
  Future<void> save(LinkedTvSnapshot snapshot) {
    final payload = jsonEncode(<String, Object?>{
      'deviceId': snapshot.deviceId,
      'displayName': snapshot.displayName,
      'lastKnownOnline': snapshot.lastKnownOnline,
      'updatedAt': snapshot.updatedAt.toUtc().toIso8601String(),
    });
    return _store.upsertSetting(
      CachedSetting(key: settingKey, value: payload),
    );
  }

  @override
  Future<void> clear() {
    return _store.upsertSetting(
      const CachedSetting(key: settingKey, value: ''),
    );
  }
}
