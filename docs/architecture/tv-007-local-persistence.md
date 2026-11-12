# TV-007 — Local persistence (Room / SQLite)

**Status:** Implemented with Drift (Flutter SQLite).  
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

## Landed

| Piece | Location |
|---|---|
| Port | [`LocalMediaStore`](../../lib/core/persistence/local_media_store.dart) |
| Memory impl | [`MemoryLocalMediaStore`](../../lib/core/persistence/memory_local_media_store.dart) (unit tests) |
| Drift schema | [`AppDatabase`](../../lib/core/persistence/drift/app_database.dart) |
| Drift adapter | [`DriftLocalMediaStore`](../../lib/core/persistence/drift/drift_local_media_store.dart) |
| URI sanitize | [`ContentItemCodec`](../../lib/core/persistence/drift/content_item_codec.dart) strips URI userInfo |
| Outbox entity | [`SyncOutboxEntry`](../../lib/features/sync/domain/entities/sync_outbox_entry.dart) |
| Source cache entity | [`CachedSource`](../../lib/features/sources/domain/entities/cached_source.dart) |
| Setting entity | [`CachedSetting`](../../lib/features/settings/domain/entities/cached_setting.dart) |
| DI | [`AppDependencies.localMediaStore`](../../lib/app/di/app_dependencies.dart) |
| Device wire | [`bootstrap`](../../lib/app/bootstrap.dart) → `DriftLocalMediaStore(AppDatabase.defaults())` |

Flutter **does not** use Android Room directly. Spec “Room / SQLite” maps to Drift + SQLite behind `LocalMediaStore`.

## Packages

| Package | Role |
|---|---|
| `drift` + `drift_flutter` | Typed SQLite (Room equivalent) |
| `path_provider` | DB file directory (via `DriftNativeOptions`) |
| `drift_dev` + `build_runner` | Codegen |

`sqlite3_flutter_libs` is **not** a direct dependency — sqlite3 3.x bundles SQLite via hooks (current Drift setup).

## Security

- Session / pairing / source **secrets** → `SecureStorage` (CMP-005), never this DB.
- `CachedSource` has no password fields; `baseUrl` / stream URIs strip userInfo on write.
- Outbox `payloadJson` must not embed credentials.
