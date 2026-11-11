# CMP-002 — Android & iOS project scaffold

Implements Sprint 0 companion/TV host scaffolding on the shared Flutter package (ADR-001).

## Modules

| Module | Path | Role |
|---|---|---|
| App shell | `lib/app/` | Bootstrap, `ClientKind`, DI mount, navigation |
| Core | `lib/core/` | Theme, widgets, platform, network helpers |
| Features | `lib/features/<name>/{domain,data,presentation}` | Clean Architecture slices |
| TV UI | `presentation/tv` | Leanback / D-pad surfaces |
| Companion UI | `presentation/companion` | Phone/tablet surfaces |
| Android host | `android/` | Flavors `tv` / `companion` |
| iOS host | `ios/` | Runner + `tv` / `companion` Flutter xcconfigs |

## DI

Manual composition root: [`AppDependencies`](../../lib/app/di/app_dependencies.dart).  
**No** get_it / riverpod / provider until explicitly approved. Adapters register here as they land.

## Navigation

Navigator 1.0 named routes: [`AppRoutes`](../../lib/app/navigation/app_routes.dart) + [`AppNavigator`](../../lib/app/navigation/app_navigator.dart).  
**No** go_router until approved.

## Build variants

### Android

```bash
flutter run --flavor tv -t lib/main_tv.dart
flutter run --flavor companion -t lib/main_companion.dart
```

Product flavors set `applicationIdSuffix` (`.tv` / `.companion`) and `app_name`.

### iOS

Entrypoint-based variants (Xcode schemes can point at these xcconfigs later):

```bash
flutter run -t lib/main_tv.dart
flutter run -t lib/main_companion.dart
```

Xcconfigs: `ios/Flutter/tv.xcconfig`, `ios/Flutter/companion.xcconfig` set `FLUTTER_TARGET`.

## CI

GitHub Actions: [`.github/workflows/ci.yml`](../../.github/workflows/ci.yml) — `flutter analyze`, `flutter test`, and debug APK builds for both Android flavors.

## Package proposals (not installed)

| Need | Candidate | Why wait |
|---|---|---|
| DI | `get_it` | Manual root is enough for Sprint 0 |
| Navigation | `go_router` | Named `Navigator` covers MVP shell |
