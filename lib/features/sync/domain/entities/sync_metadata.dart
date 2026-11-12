/// Server-authoritative sync metadata shared by TV and Companion (PRD-011 / TV-005).
///
/// [updatedAtServer] must come from the backend clock — never the device clock.
final class SyncMetadata {
  const SyncMetadata({
    required this.syncVersion,
    required this.updatedAtServer,
  });

  final int syncVersion;
  final DateTime updatedAtServer;
}
