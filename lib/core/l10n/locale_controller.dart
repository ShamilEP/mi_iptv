import 'package:flutter/foundation.dart';

import '../../features/settings/domain/entities/cached_setting.dart';
import '../persistence/local_media_store.dart';
import 'app_locale.dart';

/// Holds the active [AppLocale] and persists it (CMP-008 / NFR-012).
final class LocaleController extends ChangeNotifier {
  LocaleController({
    this._store,
    AppLocale initial = AppLocale.fallback,
  }) : _locale = initial;

  static const String settingKey = 'settings.app_locale.v1';

  final LocalMediaStore? _store;
  AppLocale _locale;

  AppLocale get locale => _locale;

  /// Loads persisted locale when a [LocalMediaStore] is available.
  Future<void> hydrate() async {
    final store = _store;
    if (store == null) return;
    final row = await store.loadSetting(settingKey);
    final next = AppLocale.parse(row?.value);
    if (next == _locale) return;
    _locale = next;
    notifyListeners();
  }

  Future<void> setLocale(AppLocale locale) async {
    if (locale == _locale) return;
    _locale = locale;
    notifyListeners();
    final store = _store;
    if (store == null) return;
    await store.upsertSetting(
      CachedSetting(key: settingKey, value: locale.languageTag),
    );
  }
}
