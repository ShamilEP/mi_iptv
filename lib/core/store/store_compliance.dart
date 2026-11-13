import 'companion_store_readiness.dart';

/// Store compliance inventory for Play TV quality + App Store / Play review
/// readiness (QA-052 / SRS §1.3).
///
/// Client-verifiable facts only. Listing identity, privacy-policy URL, and
/// final package IDs remain **Product (PRD-042)** — do not invent them here.
abstract final class StoreCompliance {
  static const String playTvDisplayName = 'Mi IPTV';

  /// Google Play Android TV packaging paths locked by TV-003.
  static const String tvManifestPath = 'android/app/src/tv/AndroidManifest.xml';
  static const String tvBannerDrawablePath =
      'android/app/src/main/res/drawable/tv_banner.png';
  static const String tvBannerBrandPath = 'assets/brand/tv_banner_320x180.png';

  static const int tvBannerWidthPx = 320;
  static const int tvBannerHeightPx = 180;

  /// Manifest tokens required for Play TV / Leanback listing.
  static const List<String> playTvManifestRequirements = <String>[
    'android.software.leanback',
    'android.hardware.touchscreen',
    'android.intent.category.LEANBACK_LAUNCHER',
    '@drawable/tv_banner',
  ];

  /// Play TV quality themes gated by existing client suites / docs.
  static const List<StoreComplianceCheck> playTvQualityChecks =
      <StoreComplianceCheck>[
    StoreComplianceCheck(
      id: 'leanback_packaging',
      title: 'Leanback launcher + 320×180 banner + touchscreen optional',
      evidence: 'TV-003 manifest + banner assets',
      automated: true,
    ),
    StoreComplianceCheck(
      id: 'dpad_focus',
      title: 'D-pad / remote-only primary paths; focus ring visible',
      evidence: 'QA-025 / TV-121 + FocusStyles / tv_accessibility',
      automated: true,
    ),
    StoreComplianceCheck(
      id: 'overscan',
      title: 'Actionable chrome inside TV overscan inset',
      evidence: 'AppOverscan (DSN-004)',
      automated: true,
    ),
    StoreComplianceCheck(
      id: 'legibility',
      title: '2–3 m type floors and contrast on TV dark',
      evidence: 'QA-037 / TV-123 distance + accessibility passes',
      automated: true,
    ),
    StoreComplianceCheck(
      id: 'no_touch_only_tv',
      title: 'No touch-only primary journeys on TV shells',
      evidence: 'TV presentation uses FocusableSurface / focus maps',
      automated: false,
    ),
    StoreComplianceCheck(
      id: 'device_matrix',
      title: 'Smoke on QA-002 matrix tier M (and L when available)',
      evidence: 'android_tv_device_matrix.md',
      automated: false,
    ),
  ];

  /// App Store / Play Companion review readiness (delegates to CMP-010).
  static const List<StoreComplianceCheck> appStorePlayCompanionChecks =
      <StoreComplianceCheck>[
    StoreComplianceCheck(
      id: 'companion_icons',
      title: 'Companion icons from DSN-005 masters',
      evidence: 'CompanionStoreReadiness.iconAssetPaths',
      automated: true,
    ),
    StoreComplianceCheck(
      id: 'companion_permissions',
      title: 'Android INTERNET-only; no ATT / extra iOS usage strings',
      evidence: 'CMP-010 permissions inventory',
      automated: true,
    ),
    StoreComplianceCheck(
      id: 'companion_privacy',
      title: 'Play Data Safety / Apple App Privacy from client facts',
      evidence: 'companion_store_privacy_checklist.md',
      automated: true,
    ),
    StoreComplianceCheck(
      id: 'companion_no_playback',
      title: 'Companion has no local video playback in MVP',
      evidence: 'CompanionStoreReadiness.reviewerNotes + product north star',
      automated: true,
    ),
    StoreComplianceCheck(
      id: 'review_account',
      title: 'Staging review account playbook (no passwords in git)',
      evidence: 'store_review_account.md',
      automated: true,
    ),
    StoreComplianceCheck(
      id: 'prd_042_listing',
      title: 'Privacy policy URL + final package / bundle IDs',
      evidence: 'Product PRD-042 — Blocked until provided',
      automated: false,
    ),
  ];

  static List<StoreComplianceCheck> get allChecks => <StoreComplianceCheck>[
        ...playTvQualityChecks,
        ...appStorePlayCompanionChecks,
      ];

  /// Non-secret cross-store reviewer blurb (TV + Companion).
  static String get reviewerNotes => '''
Mi IPTV — store compliance (QA-052)

Android TV / Google TV
1. Install the tvProd (or tvDev staging) APK on an API 34+ Google TV device.
2. Confirm Leanback launcher tile uses the 320×180 banner.
3. Navigate Home → Live → Settings with D-pad only; focus ring always visible.
4. Keep chrome inside overscan; player may be full-bleed.

Companion (App Store / Play)
${CompanionStoreReadiness.reviewerNotes}

Product (PRD-042): attach privacy policy URL and final applicationId / bundle ID
before store submission. Do not invent them in this repository.
''';
}

/// One store-compliance checklist row (QA-052).
final class StoreComplianceCheck {
  const StoreComplianceCheck({
    required this.id,
    required this.title,
    required this.evidence,
    required this.automated,
  });

  final String id;
  final String title;
  final String evidence;
  final bool automated;
}
