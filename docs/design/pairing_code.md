# Pairing code screens (DSN-071)

Executable UI:

- TV: [`TvPairingCodePage`](../../lib/features/devices/presentation/tv/tv_pairing_code_page.dart)
- Companion: [`CompanionPairingCodePage`](../../lib/features/devices/presentation/companion/companion_pairing_code_page.dart)

**Phase:** Release 2 design shell (PRD-008 — companion-to-TV pairing code).  
**Refs:** SRS §7, §23

## Flows

1. **TV — show code** — brand lockup, title, large **6-digit** code (spaced glyphs), short instruction to enter it on Companion, **Refresh code**, and a waiting cue while unpaired.
2. **TV — linked** — success icon + copy when the matching Companion code is accepted (shell callback).
3. **Companion — enter code** — brand lockup under [`CompanionPlatformShell`](../../lib/core/platform/companion_platform_shell.dart), numeric field (6 digits), **Link TV** / Cancel.
4. **Companion — wrong code** — error icon + message (state ≠ hue alone); field clears for retry.
5. **Companion — linked** — success messaging for the session.

## Demo

Expected code for the shell is `482913` ([`PairingCodeCopy.demoExpectedCode`](../../lib/features/devices/presentation/pairing_code_models.dart)) — design fixture only, **never logged**.

## Notes

- Design shell only: no pairing API, QR, or secure-store writes.
- Complements account-linked TV list on [companion_login_pairing.md](./companion_login_pairing.md) (DSN-050), which intentionally omitted the code step.
- TV uses `TvAccessibleScope`; Companion uses platform shell + system keyboard.
