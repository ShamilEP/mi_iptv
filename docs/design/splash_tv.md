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

- Design shell: callers wire `onFinished` to Home / Auth. Native Android `launch_background` stays a separate cold-start concern.
