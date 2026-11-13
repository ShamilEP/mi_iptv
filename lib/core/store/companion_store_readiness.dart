/// Companion App Store / Play review readiness inventory (CMP-010 / SRS §1.3).
///
/// Factual client facts only — no secrets, no invented Product URLs or package IDs.
abstract final class CompanionStoreReadiness {
  static const String displayName = 'Mi IPTV Companion';

  /// DSN-005 masters used for store / launcher icons.
  static const List<String> iconAssetPaths = <String>[
    'assets/brand/app_icon_512.png',
    'assets/brand/adaptive/ic_launcher_foreground.png',
    'assets/brand/adaptive/ic_launcher_background.png',
    'assets/brand/adaptive/ic_launcher_monochrome.png',
    'assets/brand/mark_companion.svg',
    'assets/brand/lockup_companion.png',
  ];

  /// Declared Android permissions required for Companion release networking.
  static const List<String> androidPermissions = <String>[
    'android.permission.INTERNET',
  ];

  /// iOS usage / tracking strings currently required (none beyond defaults).
  static const List<String> iosUsageDescriptions = <String>[];

  /// Data categories relevant to Play Data Safety / Apple App Privacy forms.
  static const List<CompanionStoreDataCategory> privacyDataCategories =
      <CompanionStoreDataCategory>[
    CompanionStoreDataCategory(
      id: 'account_credentials',
      label: 'Account credentials',
      collected: true,
      linkedToUser: true,
      purpose: 'App functionality (login / session refresh)',
      storedOnDevice: true,
      notes: 'Tokens in Keystore/Keychain via CMP-005; never logged.',
    ),
    CompanionStoreDataCategory(
      id: 'user_content_cache',
      label: 'Catalog / favorites / TV status cache',
      collected: true,
      linkedToUser: true,
      purpose: 'App functionality + offline browse (CMP-006)',
      storedOnDevice: true,
      notes: 'LocalMediaStore / Drift; no third-party stream passwords in cache.',
    ),
    CompanionStoreDataCategory(
      id: 'device_ids',
      label: 'Device or pairing identifiers',
      collected: true,
      linkedToUser: true,
      purpose: 'App functionality (linked TV status)',
      storedOnDevice: true,
      notes: 'Non-secret LinkedTvSnapshot; pairing secrets stay in secure storage.',
    ),
    CompanionStoreDataCategory(
      id: 'diagnostics',
      label: 'Crash / QoE diagnostics',
      collected: false,
      linkedToUser: false,
      purpose: 'Not enabled in MVP Companion client',
      storedOnDevice: false,
      notes: 'If added later: anonymous IDs only (SEC-C09); no email/PII.',
    ),
    CompanionStoreDataCategory(
      id: 'advertising',
      label: 'Advertising / tracking',
      collected: false,
      linkedToUser: false,
      purpose: 'Not used',
      storedOnDevice: false,
      notes: 'No ATT / Ad ID; no third-party ads SDK in MVP.',
    ),
  ];

  /// Non-secret reviewer notes (credentials provisioned outside git).
  static const String reviewerNotes = '''
Mi IPTV Companion — App Store / Play review notes

1. Install the Companion build (Android companionProd or iOS companion target).
2. Open Sign in. Use the staging review account from the private ops channel
   (never commit passwords to git).
3. After login, open Explore — browse rails; open a title; tap Play on TV.
4. Confirm there is no local video player on the phone.
5. Open Remote and Language if available; airplane mode should show cached
   Explore rails when a prior online session warmed the cache.

Privacy policy URL and final package / bundle IDs: Product (PRD-042).
''';
}

/// One row for store privacy questionnaires (CMP-010).
final class CompanionStoreDataCategory {
  const CompanionStoreDataCategory({
    required this.id,
    required this.label,
    required this.collected,
    required this.linkedToUser,
    required this.purpose,
    required this.storedOnDevice,
    required this.notes,
  });

  final String id;
  final String label;
  final bool collected;
  final bool linkedToUser;
  final String purpose;
  final bool storedOnDevice;
  final String notes;
}
