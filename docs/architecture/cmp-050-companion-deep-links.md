# CMP-050 — Companion deep links (Release 1)

**Refs:** FR-030 · US-R1-09 · Depends on **PRD-028** (phase reconciled)  
**Product lock (2026-11-17):** Deliver OS deep links in **Release 1** (human supersedes the earlier PRD-028 “Release 2” deferral for this client task).

## Interim URL scheme

HTTPS only (no custom scheme in MVP of this task):

| Target | Pattern | Example |
|---|---|---|
| VOD / title | `https://link.mi-iptv.app/vod/{contentId}` | `…/vod/movie-1` |
| Live channel | `https://link.mi-iptv.app/live/{channelId}` | `…/live/live-12` |

Host and path prefixes live in [`DeepLinkPolicy`](../../lib/features/deep_links/domain/deep_link_policy.dart).

## Behavior (Companion)

1. Parse URI → `DeepLinkTarget` or unsupported.
2. If no session JWT → route to Companion login, then continue to the target.
3. If signed in → open Explore **detail** for the matching catalog id (Send-to-TV; **no** Companion video playback).
4. Missing id → clear “content not found” messaging (not a blank screen).

## Layout

| Piece | Location |
|---|---|
| Policy + parser | `DeepLinkPolicy` / `DeepLinkParser` under `lib/features/deep_links/domain/` |
| Ingress port | `DeepLinkIngress` (domain) |
| Memory ingress | `lib/features/deep_links/data/memory_deep_link_ingress.dart` |
| Android MethodChannel | `MethodChannelDeepLinkIngress` + `DeepLinkPlugin` |
| UI binder | `CompanionDeepLinkBinder` on Companion home |
| Manifest VIEW filter | `android/app/src/main/AndroidManifest.xml` |

## Packages

No new pubspec dependency. OS URI delivery uses a thin MethodChannel (same pattern as OEM / Media3 plugins).

**Proposed later (needs approval):** `app_links` for cross-platform cold/warm start and iOS Universal Links.
