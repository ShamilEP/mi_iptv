/// Backend route prefixes for MVP BFF (`/api/v1`). No secrets here.
abstract final class ApiPaths {
  static const String root = '/api/v1';
  static const String auth = '$root/auth';
  static const String sources = '$root/sources';
  static const String catalog = '$root/catalog';
  static const String sync = '$root/sync';
  static const String devices = '$root/devices';
  static const String qoe = '$root/diagnostics/qoe';
}
