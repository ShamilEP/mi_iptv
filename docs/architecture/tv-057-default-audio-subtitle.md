# TV-057 — Default audio / subtitle track with DSN-021 styling

Depends on **DSN-021** (subtitle style) and **TV-050** (Media3).  
Refs: **FR-017** (manual selection deferred to Release 1 / DSN-064).

## Goal

On play, use the **source’s default** audio and subtitle tracks. Render cues with
[`MiSubtitleCaption`](../../lib/core/widgets/mi_subtitle_caption.dart) /
[`AppSubtitleStyle`](../../lib/core/theme/app_subtitle_style.dart) (Cloud on Ink
scrim) — never raw ExoPlayer subtitle chrome.

## Wiring

| Concern | Authority |
|---|---|
| Default pick | [`DefaultTrackPolicy`](../../lib/features/player/domain/services/default_track_policy.dart) |
| Track model | [`PlaybackTrack`](../../lib/features/player/domain/entities/playback_track.dart) |
| Cue on status | [`MediaPlayerStatus.subtitleCue`](../../lib/features/player/domain/repositories/media_player_controller.dart) |
| Native select + cues | [`Media3PlayerEngine`](../../android/app/src/main/kotlin/com/example/mi_iptv/player/Media3PlayerEngine.kt) `applySourceDefaultTracks` / `onCues` |
| Caption UI | [`MiSubtitleCaption`](../../lib/core/widgets/mi_subtitle_caption.dart) on [`TvVodPlayerPage`](../../lib/features/player/presentation/tv/tv_vod_player_page.dart) |
| Shell defaults | [`TvTrackPreference.sourceDefaults`](../../lib/features/player/presentation/tv/tv_track_models.dart) |

## Behavior (DoD)

1. **Audio** — prefer track with source `isDefault` / `SELECTION_FLAG_DEFAULT`; else first audio.
2. **Subtitles** — prefer source-default text track; if none, stay **Off**.
3. **Styling** — cues paint through DSN-021 (`AppSubtitleStyle` / `MiSubtitleCaption`).
4. **R1** — interactive picker remains DSN-064 / FR-017 selection; not required for MVP DoD.

## Validation

- `test/features/player/domain/default_track_policy_test.dart`
- `test/features/player/presentation/tv/tv_default_tracks_test.dart`
- `test/docs/tv_057_default_audio_subtitle_doc_test.dart`
- Existing DSN-021: `test/core/theme/app_subtitle_style_test.dart`
