# CMP-006 — Companion local cache and offline behavior

**Refs:** NFR-011 · Depends on **CMP-002** · Shared store **TV-007** · Connectivity **TV-010**  
**Related:** [offline_first.md](../qa/offline_first.md), [tv-010-connectivity-offline.md](./tv-010-connectivity-offline.md)

## Goal

Companion keeps **catalog**, **favorites**, and **last-known TV status** in the shared local media cache so airplane / backend-down still show clear offline surfaces — offline-with-cache (banner + rails) or full offline — and **retry / connectivity restore clears** those states.

## Layout

| Piece | Location |
|---|---|
| Browse payload | [`CompanionCachedBrowse`](../../lib/features/catalog/domain/entities/companion_cached_browse.dart) |
| Cache facade | [`CompanionLocalCache`](../../lib/features/catalog/domain/services/companion_local_cache.dart) |
| TV status | [`LinkedTvSnapshot`](../../lib/features/devices/domain/entities/linked_tv_snapshot.dart) + [`LocalLinkedTvStatusStore`](../../lib/features/devices/data/repositories/local_linked_tv_status_store.dart) |
| Cache gate | [`OfflineCacheAvailability`](../../lib/core/network/offline_cache_availability.dart) (favorites count) |
| Explore bind | [`CompanionExploreConnectivityBinder`](../../lib/features/catalog/presentation/companion/companion_explore_connectivity_binder.dart) |
| Remote bind | [`CompanionRemoteConnectivityBinder`](../../lib/features/devices/presentation/companion/companion_remote_connectivity_binder.dart) |
| Offline-cached UI | [`CompanionExploreSurfaceState.offlineCached`](../../lib/features/catalog/presentation/companion/companion_explore_copy.dart) + [`OfflineBanner`](../../lib/core/widgets/offline_banner.dart) |

## Behavior

| Connectivity | Local cache | Presentation |
|---|---|---|
| Online | — | Explore ready (demo or cached rails) |
| Offline | Channels / VOD / favorites | Offline banner + `(cached)` rails + last TV name |
| Offline | Empty | Full `OfflinePattern` (clears on retry when network returns) |

Linked TV status is non-secret JSON in settings (`devices.linked_tv_status.v1`). Pairing tokens stay in secure storage (CMP-005).

## Packages

No new pubspec dependency — Drift / connectivity already approved (TV-007 / TV-010).
