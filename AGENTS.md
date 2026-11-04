# Mi IPTV — Agent Harness

Flutter clients for **Mi IPTV / Media Center** (MVP v2.0): Android TV / Google TV (primary) and Companion (Android / iOS). This repository does **not** host the backend.

## Product north star (MVP)
- Hybrid sources: user M3U / Xtream + proprietary catalog API.
- Accounts: register/login, one profile, multi-device sync (playback progress, favorites, sources).
- TV-first Leanback / D-pad UX; Companion = remote, keyboard, browse, **send-to-TV** (no mobile video playback in MVP).
- Offline-friendly client cache; server clock + `syncVersion` conflict rules (LWW; playback prefers higher `position` in short windows).

Authoritative specs (outside repo): Backend, Frontend, Cybersecurity, Infrastructure markdowns + SRS v2.0 MVP. Prefer those over guesswork; **ask** if a decision is not closed in MVP.

## Non-negotiables
1. Never read `*.properties`, `*.env*`, or secrets files.
2. Clean Architecture; dependency rule: presentation → domain ← data.
3. Dart / Flutter conventions; DRY + SOLID.
4. No absurdly long files; extract early.
5. Shared widgets stay simple (`lib/core/widgets`).
6. Third-party packages/plugins only behind **adapters**; **propose → wait for approval** before `pubspec` changes.
7. Ask when unsure.

## Tree
```
lib/
  main.dart
  app/                 # bootstrap, MiIptvApp, composition root
  core/
    theme/             # Brand Theme 2026–27 tokens
    widgets/           # shared, simple UI atoms
    error/ network/ constants/ utils/
  features/
    <feature>/{domain,data,presentation}
      presentation/tv | presentation/companion
```

MVP features: `auth`, `home`, `live_tv`, `player`, `catalog`, `sources`, `sync`, `devices`, `search`, `settings`, `favorites`.

## Brand (quick)
Dark-first: Ink `#0A0D14`, Surface `#1A2130`, Cloud `#F0EEE9`, Signal `#2BD9C8`, Ember `#FF7A4D`.  
Fonts: Bricolage Grotesque / Figtree / JetBrains Mono (OFL bundled under `assets/fonts/`; DSN-003).  
Logo kit: mark + wordmark under `assets/brand/` (`BrandMark` / `BrandLockup`; DSN-005).  
TV focus: 4px Cloud ring + Signal glow, scale ~1.05–1.06. Implement the 12 mandatory UI states.

## Working agreement
- Propose architecture or package choices with a short rationale; do not install silently.
- Do not expand scope into EPG grid, multi-profile, companion playback, social login, or Smart TV (out of MVP).
- Security: no secrets in logs; secure storage adapter for tokens; HTTPS only.
