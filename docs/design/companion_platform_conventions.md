# Companion platform conventions (DSN-054)

Executable UI: [`CompanionPlatformConventionsPage`](../../lib/features/settings/presentation/companion/companion_platform_conventions_page.dart) on `AppTheme.companionLight()`, backed by [`CompanionPlatformConventions`](../../lib/core/platform/companion_platform_conventions.dart) and [`CompanionPlatformShell`](../../lib/core/platform/companion_platform_shell.dart).

## DoD areas

| Area | Android | iOS |
| --- | --- | --- |
| Navigation | System Back / predictive back; no extra leading chevron | Edge-swipe back + leading **Back** chevron on pushed screens |
| Safe areas | `SafeArea` for status bar and gesture / 3-button inset | `SafeArea` for notch / Dynamic Island and home indicator |
| Keyboard | System IME only (never TV OSK) | System keyboard only (never TV OSK) |
| Haptics | Selection: light impact; keys: medium impact | Selection: selection click; keys: light impact |

## Shell

[`CompanionPlatformShell`](../../lib/core/platform/companion_platform_shell.dart) applies Dynamic Type clamping, `SafeArea`, companion page inset, and tap-outside to dismiss the system keyboard. Optional `onBack` mounts [`CompanionPlatformBackAffordance`](../../lib/core/platform/companion_platform_back.dart) (iOS chevron + Back; Android empty — system Back). Login and Remote use this shell.

## Notes

- Design shell: gallery can override host platform for side-by-side review.
- Haptics call Flutter `HapticFeedback` only; no third-party packages.
