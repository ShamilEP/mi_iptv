import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/features/devices/domain/entities/pairing_secure_data.dart';

void main() {
  test('PairingSecureData toString redacts sessionSecret (SEC-022)', () {
    const data = PairingSecureData(
      linkedTvDeviceId: 'tv-living-room',
      sessionSecret: 'super-secret-pairing',
    );
    final dumped = data.toString();
    expect(dumped, contains('tv-living-room'));
    expect(dumped, contains('***'));
    expect(dumped, isNot(contains('super-secret-pairing')));
  });
}
