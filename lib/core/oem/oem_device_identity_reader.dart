import 'oem_device_identity.dart';

/// Port that reads the host OEM fingerprint (TV-011).
abstract interface class OemDeviceIdentityReader {
  Future<OemDeviceIdentity> read();
}

/// Deterministic reader for unit tests and Companion hosts.
final class MemoryOemDeviceIdentityReader implements OemDeviceIdentityReader {
  const MemoryOemDeviceIdentityReader([
    this.identity = OemDeviceIdentity.unknown,
  ]);

  final OemDeviceIdentity identity;

  @override
  Future<OemDeviceIdentity> read() async => identity;
}
