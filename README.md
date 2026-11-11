# Mi IPTV

Flutter clients for **Mi IPTV / Media Center** (MVP v2.0): Android TV / Google TV and Companion (Android / iOS).

## Agent harness

See [`AGENTS.md`](AGENTS.md) and [`.cursor/rules/`](.cursor/rules/) for architecture, security, brand, and package-approval rules.

## Run

```bash
flutter pub get
# Android (flavors required)
flutter run --flavor tv -t lib/main_tv.dart
flutter run --flavor companion -t lib/main_companion.dart
# iOS (entrypoint targets; see ios/Flutter/*.xcconfig)
flutter run -t lib/main_tv.dart
flutter run -t lib/main_companion.dart
```

Stack: [ADR-001](docs/architecture/adr-001-companion-stack-shared-domain.md) · Scaffold: [CMP-002](docs/architecture/cmp-002-android-ios-scaffold.md)

## Structure

Clean Architecture under `lib/` (`app`, `core`, `features/*`). TV and Companion share domain; UI splits under `presentation/tv` and `presentation/companion`. Backend is out of this repository.
