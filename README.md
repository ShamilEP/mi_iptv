# Mi IPTV

Flutter clients for **Mi IPTV / Media Center** (MVP v2.0): Android TV / Google TV and Companion (Android / iOS).

## Agent harness

See [`AGENTS.md`](AGENTS.md) and [`.cursor/rules/`](.cursor/rules/) for architecture, security, brand, and package-approval rules.

## Run

```bash
flutter pub get
flutter run -t lib/main_tv.dart
flutter run -t lib/main_companion.dart
```

Default `flutter run` uses the TV entry (`lib/main.dart` → `main_tv.dart`).

Stack decision: [ADR-001](docs/architecture/adr-001-companion-stack-shared-domain.md) (Flutter Companion + one shared Dart package).

## Structure

Clean Architecture under `lib/` (`app`, `core`, `features/*`). TV and Companion share domain; UI splits under `presentation/tv` and `presentation/companion`. Backend is out of this repository.
