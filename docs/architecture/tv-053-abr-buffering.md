# TV-053 — ABR and buffering

**Refs:** NFR-QOE-04 · Depends on **TV-050** · Device ceilings via **TV-011**

## Goal

Configure Media3 quality selection and buffers so TV playback is:

1. **Bandwidth-aware** — adaptive track selection with a tunable bandwidth fraction.
2. **Device-aware** — OEM max width/height / bitrate ceilings (and `conservativeAbr`).
3. **Stability-aware** — longer quality-increase hold on conservative / live profiles.
4. **Mode-split** — separate **live** vs **VOD** buffer envelopes.

## Layout

| Piece | Location |
|---|---|
| Mode | [`PlaybackMode`](../../lib/features/player/domain/entities/playback_mode.dart) on [`PlaybackRequest`](../../lib/features/player/domain/entities/playback_request.dart) |
| Profile | [`AbrBufferProfile`](../../lib/features/player/domain/entities/abr_buffer_profile.dart) |
| Policy | [`AbrBufferPolicy`](../../lib/features/player/domain/services/abr_buffer_policy.dart) |
| Dart → native | [`Media3PlayerAdapter`](../../lib/features/player/data/adapters/media3_player_adapter.dart) `abr` map |
| Native apply | [`Media3PlayerEngine`](../../android/app/src/main/kotlin/com/example/mi_iptv/player/Media3PlayerEngine.kt) `DefaultLoadControl` + `DefaultTrackSelector` / `AdaptiveTrackSelection` |

## Profiles (defaults)

| Mode | min / max buffer | forPlayback / afterRebuffer | Notes |
|---|---|---|---|
| **Live** | 1.5–10 s (2.5–12 s conservative) | 1.5 / 3 s | Lower latency |
| **VOD** | 5–50 s (7.5–40 s conservative) | 2.5 / 5 s | Deeper rebuffer budget |

Max video size / bitrate come from OEM decoder caps; `prefer1080pCeiling` clamps to 1080p; `conservativeAbr` lowers bandwidth fraction and lengthens upswitch hold.

## Packages

No new pubspec dependency — Media3 BOM already approved (TV-050).

## Security

ABR wire map carries only numeric buffer / bitrate ceilings — never stream URIs or credentials.
