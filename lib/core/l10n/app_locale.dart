import 'package:flutter/material.dart';

/// MVP UI locales locked by PRD-012 / NFR-012 (CMP-008 / TV-014).
enum AppLocale {
  en,
  es,
  zhCn,
  fr;

  /// BCP-47 / Flutter [Locale] tag.
  String get languageTag => switch (this) {
        AppLocale.en => 'en',
        AppLocale.es => 'es',
        AppLocale.zhCn => 'zh-CN',
        AppLocale.fr => 'fr',
      };

  /// Short picker label (always Latin script for the control itself).
  String get displayName => switch (this) {
        AppLocale.en => 'English',
        AppLocale.es => 'Español',
        AppLocale.zhCn => '中文（简体）',
        AppLocale.fr => 'Français',
      };

  Locale get toFlutterLocale => switch (this) {
        AppLocale.en => const Locale('en'),
        AppLocale.es => const Locale('es'),
        AppLocale.zhCn => const Locale.fromSubtags(
            languageCode: 'zh',
            countryCode: 'CN',
          ),
        AppLocale.fr => const Locale('fr'),
      };

  static const AppLocale fallback = AppLocale.en;

  static const List<AppLocale> supported = <AppLocale>[
    AppLocale.en,
    AppLocale.es,
    AppLocale.zhCn,
    AppLocale.fr,
  ];

  static AppLocale parse(String? raw) {
    final value = raw?.trim();
    if (value == null || value.isEmpty) return fallback;
    final normalized = value.replaceAll('_', '-').toLowerCase();
    return switch (normalized) {
      'en' || 'en-us' || 'en-gb' => AppLocale.en,
      'es' || 'es-es' || 'es-mx' => AppLocale.es,
      'zh-cn' || 'zh' || 'zh-hans' => AppLocale.zhCn,
      'fr' || 'fr-fr' || 'fr-ca' => AppLocale.fr,
      _ => fallback,
    };
  }
}
