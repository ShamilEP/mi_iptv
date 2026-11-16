# TV-015 — Local DB migrations and update safety

**Refs:** FR-027 · US-18 · Depends on **TV-007**  
**Stack:** Drift (Flutter SQLite) — not Android Room directly

## Goal

Versioned schema upgrades so app binary updates never corrupt favorites, playback progress, sources, settings, or sync outbox state.

## Landed

| Piece | Location |
|---|---|
| Schema + `schemaVersion` | [`AppDatabase`](../../lib/core/persistence/drift/app_database.dart) |
| Step migrations | [`AppDatabaseMigrations`](../../lib/core/persistence/drift/app_database_migrations.dart) |
| Watermark table | `LocalSchemaMetaRows` (`local_media.schema_version`) |
| Recoverable error | [`LocalMediaSchemaException`](../../lib/core/persistence/local_media_schema_exception.dart) |
| Upgrade tests | [`app_database_migrations_test.dart`](../../test/core/persistence/app_database_migrations_test.dart) |

## Version map

| Version | Change |
|---|---|
| **1** | TV-007 baseline buckets (channels, VOD, progress, favorites, sources, settings, outbox) |
| **2** | Add `LocalSchemaMetaRows` + write schema watermark on create / upgrade |

Future bumps add `if (from < N)` steps in `onUpgrade` — never edit past steps in place.

## Update safety

- Upgrades are additive; durable rows are not deleted by migration steps.
- `beforeOpen` asserts v1 core tables exist; missing tables → clear `LocalMediaSchemaException` (no silent wipe).
- Sync outbox survives upgrades so pending mutations can resume after an app update.
