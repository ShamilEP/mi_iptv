import '../entities/pairing_secure_data.dart';

/// Companion pairing data port — Keystore / Keychain via [SecureStorage].
abstract interface class PairingSecureStore {
  Future<void> save(PairingSecureData data);

  Future<PairingSecureData?> read();

  Future<void> clear();
}
