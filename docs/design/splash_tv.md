# TV Splash / Startup (DSN-030)

Executable UI: [`TvSplashPage`](../../lib/features/startup/presentation/tv/tv_splash_page.dart).

## Layout

1. **Ink canvas** — full-bleed dark startup surface.
2. **Brand lockup** — centered `BrandMark` + `iptv` wordmark (DSN-005). No secondary marketing copy, stats, or CTAs.
3. **Timing** — optional **120 ms** fade-in (`AppMotion.fast`) overlaps a **600 ms** identity hold (`AppMotion.splashHold`), then `onFinished` (wall-clock ≤ hold).

## Rules (DoD)

- Minimal identity only.
- Fast — no long animation or multi-beat intro.
- Reduced motion: skip fade; advance immediately (zero hold).

## Notes

- Product wiring: [`TvStartupGate`](../../lib/features/startup/presentation/tv/tv_startup_gate.dart) (TV-020) runs warm + JWT inspect, then routes Home / Onboarding — see [tv-020-splash-startup-routing.md](../architecture/tv-020-splash-startup-routing.md).
- Native Android `launch_background` stays a separate cold-start concern.
- Focus map: [focus_maps.md](./focus_maps.md) (DSN-040) — non-interactive brand node.
