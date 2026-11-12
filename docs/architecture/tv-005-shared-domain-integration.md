# TV-005 — Integrate the shared domain module

Depends on **PRD-011** / **ADR-001** (one Dart package) and **TV-002** (module scaffold).

## Decision consumed

Companion and Android TV share **one** root package (`mi_iptv`). Domain entities and sync rules live under `lib/features/*/domain` and are mounted once in [`AppDependencies`](../../lib/app/di/app_dependencies.dart) for both `ClientKind.tv` and `ClientKind.companion`.

## Shared contracts (Sprint 0)

| Concern | Location |
|---|---|
| Catalog entity (`ContentItem`) | `features/catalog/domain/entities/content_item.dart` |
| Catalog port | `features/catalog/domain/repositories/catalog_repository.dart` |
| Sync metadata | `features/sync/domain/entities/sync_metadata.dart` |
| Favorites entry (`FavoriteEntry`) | `features/sync/domain/entities/favorite_entry.dart` |
| Playback progress (`PlaybackProgress`) | `features/sync/domain/entities/playback_progress.dart` |
| Conflict rules | `features/sync/domain/usecases/resolve_sync_conflict.dart` |
| Sync port | `features/sync/domain/repositories/sync_repository.dart` |
| In-memory adapters | `catalog` / `sync` `data/repositories/in_memory_*.dart` |
| TV UI bridge | `features/favorites/presentation/tv/tv_favorites_from_domain.dart` |

## Sync rules (US-22)

1. **LWW** using **server** `updatedAtServer`, then `syncVersion` (never device clock).
2. **Playback progress** inside a short window (`ResolveSyncConflict.defaultPlaybackShortWindow`, 30s Sprint 0 default): higher `position` wins unless `forceReset` selects a side.

Durable SQLite (TV-007) and Companion cache (CMP-006) adapters build on this graph; see [tv-007-local-persistence.md](./tv-007-local-persistence.md).

## Bootstrap

`bootstrap(clientKind: …)` mounts `AppDependencies` with the shared `CatalogRepository`, `SyncRepository`, and `ResolveSyncConflict` for **both** entrypoints (`main_tv.dart`, `main_companion.dart`).
