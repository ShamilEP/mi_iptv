# TV Settings shell (DSN-038 → TV-080)

Executable UI: [`TvSettingsPage`](../../lib/features/settings/presentation/tv/tv_settings_page.dart).

## Layout

1. **Categories** — left rail: Account, Sources, Network, Language, Playback.
2. **Current values** — each category row shows a summary; the detail panel lists every field with its live value.
3. **Sources** — read-only priority snapshot in the shell (full management is TV-081).
4. **Diagnostics** — separate screen (TV-082); not a Settings category in MVP shell.

## Notes

- Shell uses demo values until settings repositories are wired.
- Uses `MiListRow` (DSN-013) for TV focus chrome.
