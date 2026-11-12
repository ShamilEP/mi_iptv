import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/app/app_environment.dart';
import 'package:mi_iptv/app/client_kind.dart';
import 'package:mi_iptv/app/di/app_dependencies.dart';

void main() {
  tearDown(AppDependencies.debugReset);

  test('mount exposes clientKind and environment', () {
    AppDependencies.mount(
      AppDependencies(
        clientKind: ClientKind.companion,
        environment: AppEnvironment.qa,
      ),
    );
    expect(AppDependencies.isMounted, isTrue);
    expect(AppDependencies.instance.clientKind, ClientKind.companion);
    expect(AppDependencies.instance.environment, AppEnvironment.qa);
  });

  test('environment defaults to dev when omitted', () {
    AppDependencies.mount(AppDependencies(clientKind: ClientKind.tv));
    expect(AppDependencies.instance.environment, AppEnvironment.dev);
  });

  test('instance throws before mount', () {
    expect(AppDependencies.isMounted, isFalse);
    expect(() => AppDependencies.instance, throwsStateError);
  });
}
