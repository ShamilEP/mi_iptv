import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/l10n/app_locale.dart';
import 'package:mi_iptv/core/l10n/locale_controller.dart';
import 'package:mi_iptv/core/persistence/memory_local_media_store.dart';

void main() {
  test('CMP-008 LocaleController persists and hydrates language tag', () async {
    final store = MemoryLocalMediaStore();
    final controller = LocaleController(store: store);
    await controller.setLocale(AppLocale.fr);
    expect(controller.locale, AppLocale.fr);

    final hydrated = LocaleController(store: store);
    await hydrated.hydrate();
    expect(hydrated.locale, AppLocale.fr);

    final row = await store.loadSetting(LocaleController.settingKey);
    expect(row!.value, 'fr');
  });
}
