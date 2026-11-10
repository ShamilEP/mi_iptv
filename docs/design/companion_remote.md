# Companion remote (DSN-051)

Executable UI: [`CompanionRemotePage`](../../lib/features/devices/presentation/companion/companion_remote_page.dart) on `AppTheme.companionLight()`.

## Layout

1. **Target TV** — name plus Connected or Offline (icon and text).
2. **D-pad** — large Up, Down, Left, Right, and OK.
3. **Navigation** — Back and Home.
4. **Volume** — Volume down, Mute, Volume up.
5. **Transport** — Back 10 seconds, Play, Pause, Forward 10 seconds.
6. **Keyboard** — text field and Send. Empty Send stays on the field and asks for text.

## Feedback

Every control press starts a haptic impact and fills the key with the companion primary color until release. The status line names the last control, or the text that was sent.

## Notes

- Design shell only: presses are not transmitted to a TV.
- Volume and mute use text labels. Those glyphs are not in the icon catalog.
