import '../../../../core/storage/secure_storage.dart';
import '../../../../core/storage/secure_storage_keys.dart';
import '../../domain/entities/pairing_secure_data.dart';
import '../../domain/repositories/pairing_secure_store.dart';

/// Pairing secrets in [SecureStorage] (CMP-005). Never logs secrets.
final class SecurePairingStore implements PairingSecureStore {
  SecurePairingStore(this._storage);

  final SecureStorage _storage;

  @override
  Future<void> save(PairingSecureData data) async {
    await _storage.write(
      key: SecureStorageKeys.pairingDeviceId,
      value: data.linkedTvDeviceId,
    );
    await _storage.write(
      key: SecureStorageKeys.pairingSessionSecret,
      value: data.sessionSecret,
    );
  }

  @override
  Future<PairingSecureData?> read() async {
    final deviceId =
        await _storage.read(key: SecureStorageKeys.pairingDeviceId);
    final secret =
        await _storage.read(key: SecureStorageKeys.pairingSessionSecret);
    if (deviceId == null || secret == null) return null;
    if (deviceId.isEmpty || secret.isEmpty) return null;
    return PairingSecureData(
      linkedTvDeviceId: deviceId,
      sessionSecret: secret,
    );
  }

  @override
  Future<void> clear() async {
    await _storage.delete(key: SecureStorageKeys.pairingDeviceId);
    await _storage.delete(key: SecureStorageKeys.pairingSessionSecret);
  }
}
