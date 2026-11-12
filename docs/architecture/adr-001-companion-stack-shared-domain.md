# ADR-001 — Companion stack and shared-domain approach (CMP-001 / PRD-011)

- **Status:** Accepted  
- **Date:** 2026-11-11  
- **Deciders:** Product (human) via PRD-011  
- **Refs:** SRS §5, §25; Frontend §1; tracker PRD-011, CMP-001  

## Context

Specs left open whether the Companion should be native (Kotlin + Swift), KMP, Flutter, or React Native, and how TV + Companion would share domain/sync logic.

This repository already hosts Flutter clients and Clean Architecture feature folders with `presentation/tv` and `presentation/companion`.

## Decision

1. **Companion technology:** **Flutter** for **Android and iOS** (not native-only, not React Native, not a separate KMP app).
2. **TV technology (aligned):** **Flutter** Android TV / Google TV client in the **same** repo/package (see [ADR-002](./adr-002-tv-toolkit-sdk.md) / PRD-010 for SDK levels).
3. **Shared domain:** **One Dart package** — the root package `mi_iptv` — owns domain and application use cases under `lib/features/<feature>/domain` (and shared contracts in `lib/core` where appropriate). TV and Companion **do not** duplicate domain models in separate native modules.
4. **UI split:** Presentation stays surface-specific:
   - TV: `lib/features/*/presentation/tv`
   - Companion: `lib/features/*/presentation/companion`
   - Shared visual atoms: `lib/core/widgets`
5. **Entrypoints:** Distinct Dart entry files select the client surface without forking the package:
   - TV: `lib/main_tv.dart` (default `lib/main.dart` delegates here)
   - Companion: `lib/main_companion.dart`
6. **MVP Companion scope (unchanged):** remote, browse, send-to-TV — **no** in-companion video playback.

## Consequences

- Sync, catalog, sources, auth session rules, and playback-progress policies live once in Dart domain code; both surfaces call the same use cases/repositories.
- Platform plugins (secure storage, Media3, etc.) remain behind **adapters** in `data/`; domain stays Flutter-UI-free.
- Store binaries may still be separate application IDs / flavors later; they still compile against this shared package.
- Rejected alternatives: Kotlin+Swift twin apps, React Native companion, KMP-only shared domain with thin Flutter shells.

## Executable anchors

| Concern | Location |
|---|---|
| Client surface enum (`ClientKind`) | `lib/app/client_kind.dart` |
| Bootstrap | `lib/app/bootstrap.dart` |
| Root app | `lib/app/app.dart` |
| TV entry | `lib/main_tv.dart` / `lib/main.dart` |
| Companion entry | `lib/main_companion.dart` |
