# TV-020 — Splash and startup routing

**Refs:** Frontend §2.3 · Depends on **TV-007**, **TV-008**  
**Design shell:** [splash_tv.md](../design/splash_tv.md) (DSN-030)

## Goal

Cold start shows a **short** brand splash while the client:

1. Warms local media (settings + sources — non-secret SQLite touch).
2. Inspects the stored session JWT (presence / three-segment shape only — never log tokens).
3. Routes to **Home** or **Onboarding / Auth**.

No long animation or marketing sequence.

## Layout

| Piece | Location |
|---|---|
| Splash UI | [`TvSplashPage`](../../lib/features/startup/presentation/tv/tv_splash_page.dart) |
| Gate | [`TvStartupGate`](../../lib/features/startup/presentation/tv/tv_startup_gate.dart) |
| Destinations | [`StartupDestination`](../../lib/features/startup/domain/entities/startup_destination.dart) |
| JWT inspect | [`SessionJwtInspector`](../../lib/features/startup/domain/services/session_jwt_inspector.dart) |
| Resolve | [`ResolveStartupDestination`](../../lib/features/startup/domain/usecases/resolve_startup_destination.dart) |
| Warm cache | [`WarmLocalMedia`](../../lib/features/startup/domain/usecases/warm_local_media.dart) |
| Parallel run | [`RunTvStartup`](../../lib/features/startup/domain/usecases/run_tv_startup.dart) |
| Routes | [`AppRoutes.tvSplash`](../../lib/app/navigation/app_routes.dart) → Home / [`tvOnboarding`](../../lib/app/navigation/app_routes.dart) |

## Timing

- Splash hold ≤ **600 ms** (`AppMotion.splashHold`); reduced motion advances immediately.
- Warm + JWT read run **in parallel** with the hold; navigation waits for **both**.
- Failures fail closed to **onboarding** (never hang on the splash).

## Security

- Tokens stay in `SessionTokenStore` / Keystore — not logged, not printed in errors.
- Inspector does not decode JWT claims (no extra crypto packages).
