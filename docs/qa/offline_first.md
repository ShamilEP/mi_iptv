# Offline-first behavior (QA-039)

**Refs:** NFR-004 · SRS §19 · Depends on **TV-010**  
**Executable suite:** [`test/qa/offline_first_test.dart`](../../test/qa/offline_first_test.dart)  
**Architecture:** [tv-010-connectivity-offline.md](../architecture/tv-010-connectivity-offline.md)

## Goal

Airplane mode and backend-down must **not block** playback recovery or Home interaction. Cached browse stays usable; reachability checks fail closed to offline within a hard timeout.

## Coverage

| Scenario | Automated check |
|---|---|
| **Airplane / DNS hang** | Hanging `ConnectivityProbe` resolves to offline within `probeTimeout` (~2s); monitor `start()` returns without awaiting the probe |
| **Backend down** | Unreachable probe → `OfflinePresentation.offlineCached` when cache exists; full offline when empty |
| **Interaction** | Offline-with-cache Home keeps Continue watching focus + rails; OfflineBanner **Try again** is tappable |
| **Playback** | Network stream failures use capped retries (`PlaybackRetryPolicy.maxAttempts`); no infinite reconnect loop |

## Notes

- Widget / unit level — no device farm or real airplane toggle required for this gate.
- Manual TV pass still covers physical radio-off and OEM network quirks (see [test_strategy.md](./test_strategy.md)).
- Companion offline cache / clear states: [cmp-006-companion-offline-cache.md](../architecture/cmp-006-companion-offline-cache.md) (CMP-006).
