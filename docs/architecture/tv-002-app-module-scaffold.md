# TV-002 — Android TV app module scaffold

Implements Sprint 0 TV foundations on the shared Flutter package (depends on TV-001 / ADR-002; aligns with CMP-002 / ADR-001).

## Module map

| Concern | Path | Notes |
|---|---|---|
| App shell | `lib/app/` | Bootstrap, `ClientKind`, `AppEnvironment`, DI, navigation |
| Design system | `lib/core/theme`, `lib/core/widgets` | Brand Theme 2026–27 tokens + shared atoms |
| Feature slices | `lib/features/<name>/{domain,data,presentation}` | Clean Architecture; TV UI under `presentation/tv` |
| Home | `features/home` | TV home / personalized home shells |
| Live | `features/live_tv` | Live stage + channel list (EPG grid UI is design-only / out of MVP ship) |
| VOD | `features/catalog` + `features/player` | Catalog `ContentType.vod*`; playback via `MediaPlayerController` + `TvVodPlayerPage` |
| Search | `features/search` | TV search shell |
| Favorites | `features/favorites` | TV favorites shell |
| Settings | `features/settings` | TV settings shell |
| Playback core | `features/player` + Media3 host | Port + [`Media3PlayerAdapter`](./tv-050-media3-player.md) (TV-050) |
| Data / domain | per-feature `data/` + `domain/` | Folders reserved (`.gitkeep`); entities/adapters land with feature tasks |

## DI

Manual composition root: [`AppDependencies`](../../lib/app/di/app_dependencies.dart) holds `clientKind` + `environment`.  
**No** get_it / riverpod / provider until explicitly approved.

## Navigation

Navigator 1.0: [`AppRoutes`](../../lib/app/navigation/app_routes.dart) + [`AppNavigator`](../../lib/app/navigation/app_navigator.dart).

TV shell routes: home, live, search, favorites, settings, VOD player.

## Build variants

Two Android flavor dimensions (orthogonal):

| Dimension | Flavors | Role |
|---|---|---|
| `client` | `tv`, `companion` | Surface binary (CMP-002) |
| `env` | `dev`, `qa`, `prod` | Backend / install graph (TV-002) |

Flutter `--flavor` uses the **combined** name (`tvDev`, `tvQa`, `tvProd`, `companionDev`, …). Pass matching `--dart-define=APP_ENV=dev|qa|prod` so Dart sees the same environment.

```bash
flutter run --flavor tvDev -t lib/main_tv.dart --dart-define=APP_ENV=dev
flutter run --flavor tvQa -t lib/main_tv.dart --dart-define=APP_ENV=qa
flutter run --flavor tvProd -t lib/main_tv.dart --dart-define=APP_ENV=prod
```

`applicationId` suffixes stack (e.g. `….tv.dev`). `prod` adds no env suffix.

## Package proposals (not installed)

| Need | Candidate | Why wait |
|---|---|---|
| Player engine | Media3 via MethodChannel (Option A) | Landed in TV-050 — see [tv-050-media3-player.md](./tv-050-media3-player.md) |
| DI | `get_it` | Manual root is enough for Sprint 0 |
| Navigation | `go_router` | Named `Navigator` covers MVP shell |
