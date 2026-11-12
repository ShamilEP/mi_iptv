# TV-010 — Connectivity monitoring and offline mode

**Refs:** NFR-004 · SRS §20 · Depends on **TV-007**  
**Related:** [tv-007-local-persistence.md](./tv-007-local-persistence.md), Home offline surfaces (TV-033 / DSN-017)

## Goal

Detect network / backend loss, show the Offline state, and keep **cached** catalog / continue-watching usable when the local store has data.

## Layout

| Piece | Location |
|---|---|
| Status | [`ConnectivityStatus`](../../lib/core/network/connectivity_status.dart) |
| Port | [`ConnectivityMonitor`](../../lib/core/network/connectivity_monitor.dart) |
| Probe | [`DnsLookupConnectivityProbe`](../../lib/core/network/connectivity_probe.dart) |
| Device monitor | [`PollingConnectivityMonitor`](../../lib/core/network/polling_connectivity_monitor.dart) |
| Test monitor | [`MemoryConnectivityMonitor`](../../lib/core/network/memory_connectivity_monitor.dart) |
| Policy | [`OfflineModePolicy`](../../lib/core/network/offline_mode_policy.dart) → online / offlineCached / offlineEmpty |
| Cache gate | [`OfflineCacheAvailability`](../../lib/core/network/offline_cache_availability.dart) via `LocalMediaStore` |
| Resolver | [`OfflineModeResolver`](../../lib/core/network/offline_mode_resolver.dart) in DI |
| UI banner | [`OfflineBanner`](../../lib/core/widgets/offline_banner.dart) |
| Home | [`TvHomeSurfaceState.offlineCached`](../../lib/features/home/presentation/tv/tv_home_surface_state.dart) |
| Live bind | [`TvHomeConnectivityBinder`](../../lib/features/home/presentation/tv/tv_home_connectivity_binder.dart) on TV home route |

## Behavior

| Connectivity | Local cache | Presentation |
|---|---|---|
| Online | — | Normal Home rails |
| Offline | Has channels / VOD / progress | Offline banner + rails labeled `(cached)` |
| Offline | Empty | Full `OfflinePattern` |

## Packages

No new pubspec dependency. Reachability uses `dart:io` DNS lookup behind `ConnectivityProbe`.  
**Proposed later (not installed):** `connectivity_plus` for OS-level link events — wait for explicit approval.

## Wiring

`bootstrap` mounts `PollingConnectivityMonitor` and calls `start()`. Unit tests keep `MemoryConnectivityMonitor`.
