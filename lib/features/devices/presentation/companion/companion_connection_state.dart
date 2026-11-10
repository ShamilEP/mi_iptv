import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';

/// Companion connection and notification states (DSN-053).
enum CompanionConnectionState {
  /// Phone and TV session are linked and reachable.
  connected,

  /// Session was linked and is now disconnected.
  disconnected,

  /// Pairing failed (code rejected or timed out).
  pairingError,

  /// The target TV is offline.
  tvOffline,

  /// The companion device has no network.
  noNetwork,
}

/// Locked title, message, action, icon, and accent for a connection notice.
@immutable
class CompanionConnectionNoticeSpec {
  const CompanionConnectionNoticeSpec({
    required this.state,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.iconRole,
    required this.colorRole,
  });

  final CompanionConnectionState state;
  final String title;
  final String message;
  final String actionLabel;
  final IconRole iconRole;
  final SemanticColorRole colorRole;

  static const CompanionConnectionNoticeSpec connected =
      CompanionConnectionNoticeSpec(
        state: CompanionConnectionState.connected,
        title: 'Connected',
        message: 'This phone is linked to the TV and ready to control it.',
        actionLabel: 'Continue',
        iconRole: IconRole.connected,
        colorRole: SemanticColorRole.syncedConnected,
      );

  static const CompanionConnectionNoticeSpec disconnected =
      CompanionConnectionNoticeSpec(
        state: CompanionConnectionState.disconnected,
        title: 'Disconnected',
        message: 'The link to the TV was lost. Reconnect to keep controlling it.',
        actionLabel: 'Reconnect',
        iconRole: IconRole.offline,
        colorRole: SemanticColorRole.weakNetwork,
      );

  static const CompanionConnectionNoticeSpec pairingError =
      CompanionConnectionNoticeSpec(
        state: CompanionConnectionState.pairingError,
        title: 'Pairing error',
        message: 'Pairing did not finish. Check the code on the TV and try again.',
        actionLabel: 'Try again',
        iconRole: IconRole.error,
        colorRole: SemanticColorRole.streamFailed,
      );

  static const CompanionConnectionNoticeSpec tvOffline =
      CompanionConnectionNoticeSpec(
        state: CompanionConnectionState.tvOffline,
        title: 'TV offline',
        message: 'That TV is offline. Turn it on or pick another linked TV.',
        actionLabel: 'Choose TV',
        iconRole: IconRole.offline,
        colorRole: SemanticColorRole.weakNetwork,
      );

  static const CompanionConnectionNoticeSpec noNetwork =
      CompanionConnectionNoticeSpec(
        state: CompanionConnectionState.noNetwork,
        title: 'No network',
        message:
            'This phone is offline. Connect to Wi-Fi or mobile data to continue.',
        actionLabel: 'Retry',
        iconRole: IconRole.offline,
        colorRole: SemanticColorRole.weakNetwork,
      );

  static CompanionConnectionNoticeSpec of(CompanionConnectionState state) {
    switch (state) {
      case CompanionConnectionState.connected:
        return connected;
      case CompanionConnectionState.disconnected:
        return disconnected;
      case CompanionConnectionState.pairingError:
        return pairingError;
      case CompanionConnectionState.tvOffline:
        return tvOffline;
      case CompanionConnectionState.noNetwork:
        return noNetwork;
    }
  }

  static const List<CompanionConnectionNoticeSpec> all = <CompanionConnectionNoticeSpec>[
    connected,
    disconnected,
    pairingError,
    tvOffline,
    noNetwork,
  ];
}
