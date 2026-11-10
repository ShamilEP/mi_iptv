/// Whether a linked TV is reachable from the Companion (DSN-050).
enum CompanionTvConnection {
  /// The TV is linked and currently connected.
  connected,

  /// The TV is linked and currently offline.
  offline,
}

/// A TV linked to the signed-in account.
class CompanionLinkedTv {
  const CompanionLinkedTv({required this.name, required this.connection});

  /// Display name of the TV.
  final String name;

  /// Visible connection state for this TV.
  final CompanionTvConnection connection;
}
