import 'package:drift/drift.dart';

import '../local_media_schema_exception.dart';
import 'app_database.dart';

/// Versioned Drift migrations for [AppDatabase] (TV-015 / FR-027).
///
/// Spec “Room migrations” → Drift step upgrades so app binary updates never
/// drop favorites, playback progress, sources, or sync outbox rows.
abstract final class AppDatabaseMigrations {
  /// Current on-disk schema. Bump only with a matching `onUpgrade` step.
  static const int currentSchemaVersion = 2;

  /// Watermark key stored in [LocalSchemaMetaRows] after create / upgrade.
  static const String metaSchemaVersionKey = 'local_media.schema_version';

  /// Tables shipped in schema v1 (TV-007). Used by upgrade tests.
  static const List<String> v1TableNames = <String>[
    'cached_channels',
    'cached_vod_items',
    'playback_progress_rows',
    'favorite_rows',
    'source_rows',
    'setting_rows',
    'outbox_rows',
  ];

  static MigrationStrategy strategyFor(AppDatabase db) {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        await writeSchemaWatermark(db);
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.createTable(db.localSchemaMetaRows);
        }
        // Future versions: add `if (from < 3) { ... }` steps here.
        await writeSchemaWatermark(db);
      },
      beforeOpen: (OpeningDetails details) async {
        await assertCoreTablesPresent(db);
        if (db.schemaVersion >= 2) {
          await writeSchemaWatermark(db);
        }
      },
    );
  }

  /// Creates only the v1 table set (no [LocalSchemaMetaRows]) for upgrade tests.
  static Future<void> createV1Tables(Migrator m, AppDatabase db) async {
    await m.createTable(db.cachedChannels);
    await m.createTable(db.cachedVodItems);
    await m.createTable(db.playbackProgressRows);
    await m.createTable(db.favoriteRows);
    await m.createTable(db.sourceRows);
    await m.createTable(db.settingRows);
    await m.createTable(db.outboxRows);
  }

  static Future<void> writeSchemaWatermark(AppDatabase db) async {
    await db.into(db.localSchemaMetaRows).insertOnConflictUpdate(
          LocalSchemaMetaRowsCompanion.insert(
            key: metaSchemaVersionKey,
            value: '${db.schemaVersion}',
          ),
        );
  }

  static Future<String?> readSchemaWatermark(AppDatabase db) async {
    final row = await (db.select(db.localSchemaMetaRows)
          ..where((t) => t.key.equals(metaSchemaVersionKey)))
        .getSingleOrNull();
    return row?.value;
  }

  static Future<void> assertCoreTablesPresent(AppDatabase db) async {
    final rows = await db
        .customSelect(
          "SELECT name FROM sqlite_master WHERE type = 'table'",
        )
        .get();
    final names = rows.map((r) => r.read<String>('name')).toSet();
    for (final table in v1TableNames) {
      if (!names.contains(table)) {
        throw LocalMediaSchemaException(
          'Local media database is missing table "$table". '
          'Durable cache may be corrupted after an update. '
          'The app can recover by rebuilding the cache; favorites, progress, '
          'and sources will re-sync when online — data was not wiped silently.',
        );
      }
    }
  }
}
