import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/app/app_environment.dart';

void main() {
  test('parse maps known labels and defaults unknown to dev', () {
    expect(AppEnvironment.parse('dev'), AppEnvironment.dev);
    expect(AppEnvironment.parse('QA'), AppEnvironment.qa);
    expect(AppEnvironment.parse('production'), AppEnvironment.prod);
    expect(AppEnvironment.parse(null), AppEnvironment.dev);
    expect(AppEnvironment.parse('nope'), AppEnvironment.dev);
  });

  test('applicationIdSuffix is empty only for prod', () {
    expect(AppEnvironment.dev.applicationIdSuffix, '.dev');
    expect(AppEnvironment.qa.applicationIdSuffix, '.qa');
    expect(AppEnvironment.prod.applicationIdSuffix, isEmpty);
  });
}
