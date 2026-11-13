import 'oem_manufacturer.dart';

/// Fingerprint used to resolve OEM profiles (TV-011).
///
/// Values come from the Android host (`Build.*`) or test fixtures — never from
/// secrets or account data.
final class OemDeviceIdentity {
  const OemDeviceIdentity({
    required this.manufacturer,
    this.manufacturerRaw = '',
    this.model = '',
    this.apiLevel = 34,
  });

  /// Safe default when the host cannot be read (unit tests, Companion).
  static const OemDeviceIdentity unknown = OemDeviceIdentity(
    manufacturer: OemManufacturer.unknown,
  );

  final OemManufacturer manufacturer;
  final String manufacturerRaw;
  final String model;

  /// Android SDK_INT. MVP TV floor is API 34 (ADR-002).
  final int apiLevel;

  factory OemDeviceIdentity.fromHost({
    required String? manufacturer,
    String? model,
    int? apiLevel,
  }) {
    return OemDeviceIdentity(
      manufacturer: OemManufacturerParser.parse(manufacturer),
      manufacturerRaw: (manufacturer ?? '').trim(),
      model: (model ?? '').trim(),
      apiLevel: apiLevel ?? 34,
    );
  }
}
