# TV-056 — Handle audio state

Depends on **TV-050** (Media3 controller).  
Refs: **NFR-QOE-06**.

## Goal

Preserve the viewer’s **mute** choice and **never change volume** unless the user
asks (remote / on-screen volume controls). Play, pause, seek, retry, zap, and
audio-focus interrupts must not reset loudness.

## Wiring

| Concern | Authority |
|---|---|
| Domain state | [`PlaybackAudioState`](../../lib/features/player/domain/entities/playback_audio_state.dart) |
| Port | [`MediaPlayerController.setAudioState`](../../lib/features/player/domain/repositories/media_player_controller.dart) / `audioState` |
| Media3 adapter | [`Media3PlayerAdapter`](../../lib/features/player/data/adapters/media3_player_adapter.dart) — `setAudioState` + play re-sends mute/volume |
| Native | [`Media3PlayerEngine.setAudioState`](../../android/app/src/main/kotlin/com/example/mi_iptv/player/Media3PlayerEngine.kt) — re-applies after ExoPlayer rebuild |
| VOD chrome | [`VodTransportSession`](../../lib/features/player/presentation/tv/vod_transport_session.dart) — mute/volume only via toggle/up/down |

## Rules (DoD)

1. **User-only mutations** — `setAudioState` / volume chrome; never from session coordinator pause or retry.
2. **Preserve mute** — `play` / player rebuild re-applies last mute + volume.
3. **Mute keeps level** — muted stores prior `volume` so unmute restores it.
4. **Focus loss** — pauses playback only; does not touch mute/volume.

## Validation

- `test/features/player/domain/playback_audio_state_test.dart`
- `test/features/player/presentation/tv/vod_transport_audio_test.dart`
- `test/features/player/data/media3_player_adapter_test.dart` (TV-056 case)
- `test/docs/tv_056_handle_audio_state_doc_test.dart`
