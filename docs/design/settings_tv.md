# TV Settings, Sources, and Diagnostics (DSN-038)

Executable UI: [`TvSettingsPage`](../../lib/features/settings/presentation/tv/tv_settings_page.dart).

## Layout

1. **Categories** — left rail: Playback, Account, Sources, Diagnostics (hierarchical selection).
2. **Current values** — Playback / Account panels show each setting with its live value in the subtitle.
3. **Sources** — ordered list with **Move up** / **Move down** to change priority.
4. **Diagnostics** — Network, Active source, Latency, Buffer, Version.

## Notes

- Design shell only: reordering is local state; diagnostics are demo values.
- Uses `MiListRow` / `MiButton` (DSN-013) for TV focus chrome.
