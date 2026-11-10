# Companion login and TV pairing (DSN-050)

Executable UI: [`CompanionLoginPairingPage`](../../lib/features/auth/presentation/companion/companion_login_pairing_page.dart) on `AppTheme.companionLight()`.

## Layout

1. **Sign in** — email and password for the account, then **Log in**. Empty fields stay on this step and ask for both.
2. **Account** — the signed-in email stays visible with the TV list.
3. **Linked TVs** — one row per TV. Each row shows a labeled connection state: **Connected** or **Offline** (icon plus text).
4. **Empty list** — “No linked TVs on this account.” No pairing-code or QR step; that mechanism is not specified here.

## Notes

- Companion light surface (`cloud` background, `ink` text, companion lockup).
- Design shell only: Log in does not call `/api/v1/auth/*` or a pairing API.
