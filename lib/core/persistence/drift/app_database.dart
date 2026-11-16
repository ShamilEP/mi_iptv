import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'app_database_migrations.dart';

part 'app_database.g.dart';

/// Durable SQLite schema for local media cache / sync outbox (TV-007 / TV-015).
class CachedChannels extends Table {
  TextColumn get contentId => text()();
  TextColumn get title => text()();
  TextColumn get type => text()();
  TextColumn get posterUrl => text().nullable()();
  TextColumn get bannerUrl => text().nullable()();
  TextColumn get genresJson => text().withDefault(const Constant('[]'))();
  TextColumn get sourcesJson => text().withDefault(const Constant('[]'))();

  @override
  Set<Column<Object>> get primaryKey => {contentId};
}

class CachedVodItems extends Table {
  TextColumn get contentId => text()();
  TextColumn get title => text()();
  TextColumn get type => text()();
  TextColumn get posterUrl => text().nullable()();
  TextColumn get bannerUrl => text().nullable()();
  TextColumn get genresJson => text().withDefault(const Constant('[]'))();
  TextColumn get sourcesJson => text().withDefault(const Constant('[]'))();

  @override
  Set<Column<Object>> get primaryKey => {contentId};
}

class PlaybackProgressRows extends Table {
  TextColumn get contentId => text()();
  IntColumn get positionMs => integer()();
  IntColumn get durationMs => integer().nullable()();
  IntColumn get syncVersion => integer()();
  DateTimeColumn get updatedAtServer => dateTime()();
  BoolColumn get forceReset =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {contentId};
}

class FavoriteRows extends Table {
  TextColumn get contentId => text()();
  TextColumn get contentType => text()();
  TextColumn get title => text()();
  IntColumn get sortOrder => integer()();
  IntColumn get syncVersion => integer()();
  DateTimeColumn get updatedAtServer => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {contentId};
}

/// Source descriptors only — never passwords or tokens (SEC-C07).
class SourceRows extends Table {
  TextColumn get sourceId => text()();
  TextColumn get kind => text()();
  TextColumn get displayName => text()();
  TextColumn get baseUrl => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {sourceId};
}

class SettingRows extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

class OutboxRows extends Table {
  TextColumn get id => text()();
  TextColumn get entityKind => text()();
  TextColumn get operation => text()();
  TextColumn get entityId => text()();
  TextColumn get payloadJson => text()();
  DateTimeColumn get enqueuedAt => dateTime()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Schema watermark / migration bookkeeping (TV-015). Non-secret only.
class LocalSchemaMetaRows extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

@DriftDatabase(
  tables: [
    CachedChannels,
    CachedVodItems,
    PlaybackProgressRows,
    FavoriteRows,
    SourceRows,
    SettingRows,
    OutboxRows,
    LocalSchemaMetaRows,
  ],
)
final class AppDatabase extends _$AppDatabase {
  AppDatabase(
    super.executor, {
    int? schemaVersionOverride,
    MigrationStrategy? migrationOverride,
  })  : _schemaVersionOverride = schemaVersionOverride,
        _migrationOverride = migrationOverride;

  /// Device default — file under application support directory.
  AppDatabase.defaults()
      : _schemaVersionOverride = null,
        _migrationOverride = null,
        super(
          driftDatabase(
            name: 'mi_iptv_local_media',
            native: const DriftNativeOptions(
              databaseDirectory: getApplicationSupportDirectory,
            ),
          ),
        );

  /// Opens a DB as schema v1 (TV-007 shape) for upgrade-safety tests (TV-015).
  factory AppDatabase.legacyV1(QueryExecutor executor) {
    late final AppDatabase db;
    db = AppDatabase(
      executor,
      schemaVersionOverride: 1,
      migrationOverride: MigrationStrategy(
        onCreate: (m) => AppDatabaseMigrations.createV1Tables(m, db),
      ),
    );
    return db;
  }

  final int? _schemaVersionOverride;
  final MigrationStrategy? _migrationOverride;

  @override
  int get schemaVersion =>
      _schemaVersionOverride ?? AppDatabaseMigrations.currentSchemaVersion;

  @override
  MigrationStrategy get migration =>
      _migrationOverride ?? AppDatabaseMigrations.strategyFor(this);
}
