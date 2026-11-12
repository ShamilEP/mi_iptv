import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

/// Durable SQLite schema for local media cache / sync outbox (TV-007).
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

@DriftDatabase(
  tables: [
    CachedChannels,
    CachedVodItems,
    PlaybackProgressRows,
    FavoriteRows,
    SourceRows,
    SettingRows,
    OutboxRows,
  ],
)
final class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  /// Device default — file under application support directory.
  AppDatabase.defaults()
      : super(
          driftDatabase(
            name: 'mi_iptv_local_media',
            native: const DriftNativeOptions(
              databaseDirectory: getApplicationSupportDirectory,
            ),
          ),
        );

  @override
  int get schemaVersion => 1;
}
