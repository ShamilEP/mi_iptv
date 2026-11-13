import 'dart:async';
import 'dart:io';

/// One-shot reachability check used by [PollingConnectivityMonitor] (TV-010).
abstract interface class ConnectivityProbe {
  /// Returns true when the network / backend appears reachable.
  Future<bool> isReachable();
}

/// DNS lookup probe — no extra pubspec packages (NFR-004 / QA-039).
///
/// Resolves [host] via [InternetAddress.lookup]. Failures and timeouts map to
/// offline so airplane mode / backend loss cannot hang the client.
final class DnsLookupConnectivityProbe implements ConnectivityProbe {
  const DnsLookupConnectivityProbe({
    this.host = 'dns.google',
    this.timeout = defaultTimeout,
  });

  /// Bound for a single lookup — must stay short so startup / polls never stall.
  static const Duration defaultTimeout = Duration(seconds: 2);

  /// Public DNS hostname used only as a reachability signal (not an API call).
  final String host;

  /// Max wait before treating the network as offline.
  final Duration timeout;

  @override
  Future<bool> isReachable() async {
    try {
      final results = await InternetAddress.lookup(host).timeout(timeout);
      return results.isNotEmpty && results.first.rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    } on TimeoutException {
      return false;
    } on ArgumentError {
      return false;
    }
  }
}
