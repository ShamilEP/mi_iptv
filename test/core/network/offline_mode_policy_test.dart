import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/core/network/connectivity_status.dart';
import 'package:mi_iptv/core/network/offline_mode_policy.dart';

void main() {
  test('TV-010 policy maps connectivity + cache to presentation', () {
    expect(
      OfflineModePolicy.resolve(
        connectivity: ConnectivityStatus.online,
        hasCachedContent: false,
      ),
      OfflinePresentation.online,
    );
    expect(
      OfflineModePolicy.resolve(
        connectivity: ConnectivityStatus.offline,
        hasCachedContent: true,
      ),
      OfflinePresentation.offlineCached,
    );
    expect(
      OfflineModePolicy.resolve(
        connectivity: ConnectivityStatus.offline,
        hasCachedContent: false,
      ),
      OfflinePresentation.offlineEmpty,
    );
  });
}
