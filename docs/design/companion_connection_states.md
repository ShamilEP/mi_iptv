# Companion connection and notification states (DSN-053)

Executable UI: [`CompanionConnectionStatesPage`](../../lib/features/devices/presentation/companion/companion_connection_states_page.dart) on `AppTheme.companionLight()`, built from [`CompanionConnectionNotice`](../../lib/features/devices/presentation/companion/companion_connection_notice.dart).

## States

| State | Title | Accent role | Icon role |
| --- | --- | --- | --- |
| Connected | Connected | Success / syncedConnected | connected |
| Disconnected | Disconnected | Warning / weakNetwork | offline |
| Pairing error | Pairing error | Error / streamFailed | error |
| TV offline | TV offline | Warning / weakNetwork | offline |
| No network | No network | Warning / weakNetwork | offline |

Each notice pairs accent with icon + title (DSN-002 / DSN-010), shows a short message, and may offer a primary action (Continue, Reconnect, Try again, Choose TV, Retry).

## Notes

- Companion light surface (`cloud` background, `ink` text, companion lockup).
- Design shell only: actions do not call pairing, device, or connectivity APIs.
- Linked-TV row labels from DSN-050 stay Connected / Offline; this task owns the five session notification banners.
