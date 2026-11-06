# TV Onboarding & Auth (DSN-031)

Executable UI: [`TvOnboardingAuthPage`](../../lib/features/auth/presentation/tv/tv_onboarding_auth_page.dart).

## Short steps (DoD)

1. **Register / Login** — email + password; TV OSK + **Type from your phone** (Companion text).
2. **Preferences** — minimal MVP placeholder; continue or **Continue later**.
3. **Add source** — HTTPS source URL via OSK / Companion; **Validate**.
4. **Validation result** — success or retry.
5. **Continue later** — leave and return to login.

Global **Continue later** control on every step header. Brand lockup + overscan padding. No invented preference catalog — product options stay for a later decision.
