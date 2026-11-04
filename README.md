# Mi IPTV

Flutter clients for **Mi IPTV / Media Center** (MVP v2.0): Android TV / Google TV and Companion (Android / iOS).

## Agent harness

See [`AGENTS.md`](AGENTS.md) and [`.cursor/rules/`](.cursor/rules/) for architecture, security, brand, and package-approval rules.

## Run

```bash
flutter pub get
flutter run
```

## Structure

Clean Architecture under `lib/` (`app`, `core`, `features/*`). Backend is out of this repository.
