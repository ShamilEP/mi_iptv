# ADR-002 — Android TV toolkit and SDK levels (TV-001 / PRD-010)

- **Status:** Accepted  
- **Date:** 2026-11-12  
- **Deciders:** Product (human) via PRD-010  
- **Refs:** Frontend §2.1; NFR-009; tracker PRD-010, TV-001; [QA device matrix](../qa/android_tv_device_matrix.md)

## Context

Frontend specs described the TV surface as “optimized for Leanback,” leaving open whether the shippable client would be native **Kotlin + Leanback**, **Jetpack Compose for TV**, or another stack, and which **min / target SDK** and hardware tier would apply.

PRD-010 closed the product gap. This ADR records that decision for the Flutter client repo and pins the Gradle values that implement it.

## Decision

1. **TV technology:** **Flutter** for Android TV / Google TV (same shared Dart package as Companion). **Not** a native Leanback or Compose-for-TV app.
2. **UI toolkit meaning of “Leanback”:** TV-first **D-pad / remote Focus** UX under `lib/features/*/presentation/tv` and shared atoms in `lib/core/widgets`. Native `androidx.leanback` / Compose for TV are **out of scope** for MVP UI.
3. **Language / host:** Dart/Flutter app code; Android host remains the standard Flutter Gradle/Kotlin DSL project (`android/`).
4. **Minimum SDK (TV flavor):** **API 34** (Android 14). Devices below API 34 are not MVP TV certification targets.
5. **Target / compile SDK:** **Latest** stable values provided by the Flutter Android toolchain (`flutter.targetSdkVersion` / `flutter.compileSdkVersion`; currently **36** on Flutter 3.47 stable).
6. **Hardware tier:** Living-room TVs / sticks up to ~**5 years old** as the performance envelope (RAM/SoC/thermal), **not** a license to ship on OS versions below API 34.
7. **Companion Android minSdk:** Unchanged by this ADR — remains Flutter’s default (`flutter.minSdkVersion`) on the `companion` flavor until a separate Product decision.

## Consequences

- TV APK / AAB built with `--flavor tv` requires API 34+.
- QA matrix and lab devices must run API 34+ ([android_tv_device_matrix.md](../qa/android_tv_device_matrix.md)).
- Leanback **launcher** wiring (`LEANBACK_LAUNCHER`, banner) stays with TV launcher tasks (e.g. TV-003), not this ADR.
- Rejected alternatives: Kotlin Leanback-only app, Compose for TV as the primary UI toolkit, minSdk &lt; 34 for the TV flavor.

## Executable anchors

| Concern | Location |
|---|---|
| TV entry | `lib/main_tv.dart` |
| Client surface | `lib/app/client_kind.dart` (`ClientKind.tv`) |
| Android flavors + SDK | `android/app/build.gradle.kts` |
| Companion stack ADR | [adr-001-companion-stack-shared-domain.md](./adr-001-companion-stack-shared-domain.md) |
