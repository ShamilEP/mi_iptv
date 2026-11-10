# Companion Explore and Send-to-TV (DSN-052)

Executable UI: [`CompanionExplorePage`](../../lib/features/catalog/presentation/companion/companion_explore_page.dart) on `AppTheme.companionLight()`.

## Layout

1. **Showcase catalog** — Featured (landscape), Live channels (tiles), and Movies (posters). Browse only; no local video player.
2. **Title detail** — selected card, title, subtitle, target TV name.
3. **Reproducir en TV** — prominent Ember / companionLive CTA (`ControlEmphasis.sendToTv`). Confirms send with a status line.
4. **No player** — copy states that video does not play on the phone. There is no video stage or playback chrome.

## Notes

- Design shell only: Send-to-TV does not call a devices or cast API.
- Button fill uses `brand.live` (companionLive on light) with Cloud label text for contrast.
