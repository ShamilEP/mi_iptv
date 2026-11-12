# TV-003 — Android TV manifest and launcher requirements

Depends on **TV-001** (Flutter TV + API 34) and **DSN-005** (logo / 320×180 banner kit).

## Goals

Meet Google Play Android TV / Leanback launcher packaging so the **`tv`** flavor installs and appears on the Google TV / Android TV launcher with a valid banner, without requiring a touchscreen.

## Manifest (TV flavor only)

Source set: [`android/app/src/tv/AndroidManifest.xml`](../../android/app/src/tv/AndroidManifest.xml)  
Merged only into `tv*` variants (not Companion).

| Requirement | Implementation |
|---|---|
| Leanback launcher entry | `MAIN` + `LEANBACK_LAUNCHER` intent-filter on `MainActivity` |
| Home-screen banner | `android:banner="@drawable/tv_banner"` (320×180 PNG from DSN-005) |
| Touchscreen not required | `android.hardware.touchscreen` `required="false"` |
| Leanback software feature | `android.software.leanback` `required="true"` (TV APK is TV-only) |
| Optional input | `faketouch` / `gamepad` `required="false"` |

Shared shell still keeps a standard `LAUNCHER` filter in [`android/app/src/main/AndroidManifest.xml`](../../android/app/src/main/AndroidManifest.xml) for sideload / non-Leanback debug hosts. Companion flavors do **not** merge the TV Leanback block.

## Banner asset

| Asset | Path | Size |
|---|---|---|
| Android drawable | `android/app/src/main/res/drawable/tv_banner.png` | **320×180** |
| Brand kit master | `assets/brand/tv_banner_320x180.png` | **320×180** |

Do not substitute a different aspect ratio; Play rejects non-320×180 banners.

## D-pad / remote-only UX (client)

Manifest declares non-touch hardware; product UX must remain D-pad first:

- Focusable chrome via shared TV widgets (`FocusableSurface`, focus maps).
- No touch-only primary paths on TV shells (home, live, search, favorites, settings, VOD player).
- Companion remains the touch remote / browse surface.

Full Play TV quality (performance, overscan, focus visibility) continues under QA device matrix and accessibility docs; this task locks **packaging** requirements.

## Build

```bash
# After TV-002 env flavors land on the branch you use:
flutter run --flavor tvDev -t lib/main_tv.dart --dart-define=APP_ENV=dev
# Or client-only flavor name if env dimension is not yet merged:
flutter run --flavor tv -t lib/main_tv.dart
```

Inspect merged manifest under `build/app/intermediates/merged_manifests/` for `LEANBACK_LAUNCHER` and `touchscreen` `required=false`.
