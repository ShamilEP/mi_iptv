# TV-007 — Local persistence (Room / SQLite)

**Status:** Blocked on SQLite package approval.  
**Refs:** NFR-011; Infra §5; tracker TV-007. Related: CMP-006 (Companion cache), TV-005 (shared domain), CMP-005 (secrets stay in Keystore/Keychain).

## Goal

Durable on-device cache for offline-friendly TV / shared clients:

| Bucket | Contents |
|---|---|
| Channels | Live `ContentItem` rows (`ContentType.channel`) |
| VOD metadata | Movies / series `ContentItem` rows |
| Playback state | `PlaybackProgress` |
| Favorites | `FavoriteEntry` |
| Sources | `CachedSource` — **no passwords / tokens** (SEC-C07) |
| Settings | `CachedSetting` non-secret prefs |
| Sync outbox | `SyncOutboxEntry` pending mutations |

## Landed (plugin-free)

| Piece | Location |
|---|---|
| Port | [`LocalMediaStore`](../../lib/core/persistence/local_media_store.dart) |
| Memory impl | [`MemoryLocalMediaStore`](../../lib/core/persistence/memory_local_media_store.dart) |
| Outbox entity | [`SyncOutboxEntry`](../../lib/features/sync/domain/entities/sync_outbox_entry.dart) |
| Source cache entity | [`CachedSource`](../../lib/features/sources/domain/entities/cached_source.dart) |
| Setting entity | [`CachedSetting`](../../lib/features/settings/domain/entities/cached_setting.dart) |
| DI | [`AppDependencies.localMediaStore`](../../lib/app/di/app_dependencies.dart) |

Flutter **does not** use Android Room directly. Spec “Room / SQLite” maps to a Flutter SQLite stack behind `LocalMediaStore`.

## Package proposal (needs explicit approval)

| Need | Candidate | Why | Alternatives |
|---|---|---|---|
| Typed SQLite | **`drift`** + **`drift_flutter`** (+ `sqlite3_flutter_libs`) | Closest Flutter equivalent to Room (tables, migrations, type-safe queries); fits adapter pattern | `sqflite` (more manual SQL); Hive/Isar (not SQLite — diverges from task title) |

After approval: generate Drift tables matching the buckets above → `DriftLocalMediaStore implements LocalMediaStore` → default it in device `bootstrap`; keep `MemoryLocalMediaStore` for unit tests.

## Security

- Session / pairing / source **secrets** → `SecureStorage` (CMP-005), never this DB.
- Outbox `payloadJson` must not embed credentials.
