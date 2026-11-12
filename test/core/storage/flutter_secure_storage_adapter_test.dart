import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/storage/flutter_secure_storage_adapter.dart';
import 'package:mi_iptv/core/storage/secure_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    FlutterSecureStorage.setMockInitialValues(<String, String>{});
  });

  test('adapter implements SecureStorage and round-trips via plugin', () async {
    final SecureStorage storage = FlutterSecureStorageAdapter(
      plugin: const FlutterSecureStorage(),
    );

    await storage.write(key: 'k', value: 'secret-value');
    expect(await storage.read(key: 'k'), 'secret-value');

    await storage.delete(key: 'k');
    expect(await storage.read(key: 'k'), isNull);

    await storage.write(key: 'a', value: '1');
    await storage.write(key: 'b', value: '2');
    await storage.clear();
    expect(await storage.read(key: 'a'), isNull);
    expect(await storage.read(key: 'b'), isNull);
  });
}
