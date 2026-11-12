import 'dart:io';

/// One-shot reachability check used by [PollingConnectivityMonitor] (TV-010).
abstract interface class ConnectivityProbe {
  /// Returns true when the network / backend appears reachable.
  Future<bool> isReachable();
}

/// DNS lookup probe — no extra pubspec packages (NFR-004).
///
/// Resolves [host] via [InternetAddress.lookup]. Failures map to offline.
final class DnsLookupConnectivityProbe implements ConnectivityProbe {
  const DnsLookupConnectivityProbe({
    this.host = 'dns.google',
  });

  /// Public DNS hostname used only as a reachability signal (not an API call).
  final String host;

  @override
  Future<bool> isReachable() async {
    try {
      final results = await InternetAddress.lookup(host);
      return results.isNotEmpty && results.first.rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    } on ArgumentError {
      return false;
    }
  }
}
