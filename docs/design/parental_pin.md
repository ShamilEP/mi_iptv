# Parental PIN flows (DSN-062)

Executable UI:

- TV: [`TvParentalPinPage`](../../lib/features/profiles/presentation/tv/tv_parental_pin_page.dart)
- Companion: [`CompanionParentalPinPage`](../../lib/features/profiles/presentation/companion/companion_parental_pin_page.dart)

**Phase:** Release 1 design shell (depends on DSN-061 profiles). Not MVP ship scope for multi-profile / durable PIN storage.

## Flows

1. **Restricted content** — lock icon + copy explaining kid-profile lock; **Enter PIN** / **Ask a parent**.
2. **PIN entry**
   - **TV** — four obscured slots + numeric D-pad pad (`TvOskKey` / `keyboardKey` focus).
   - **Companion** — system numeric keyboard via `MiTextField` (obscured) under `CompanionPlatformShell`.
3. **Wrong PIN** — error icon + message; slots clear (state ≠ hue alone).
4. **Unlocked** — success messaging for the session.

## Demo

Expected PIN for the shell is `1234` ([`ParentalPinCopy.demoExpectedPin`](../../lib/features/profiles/presentation/parental_pin_models.dart)) — design fixture only, never logged.

## Notes

- No PIN persistence, hashing, or backend calls in this shell.
- TV offers **Type from your phone** hint toward Companion entry.
