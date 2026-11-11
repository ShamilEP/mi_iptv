import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/app/client_kind.dart';
import 'package:mi_iptv/app/di/app_dependencies.dart';

void main() {
  tearDown(AppDependencies.debugReset);

  test('mount exposes clientKind', () {
    AppDependencies.mount(AppDependencies(clientKind: ClientKind.companion));
    expect(AppDependencies.isMounted, isTrue);
    expect(AppDependencies.instance.clientKind, ClientKind.companion);
  });

  test('instance throws before mount', () {
    expect(AppDependencies.isMounted, isFalse);
    expect(() => AppDependencies.instance, throwsStateError);
  });
}
