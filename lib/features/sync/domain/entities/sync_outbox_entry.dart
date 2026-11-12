/// Pending multi-device sync mutation waiting for network (TV-007 / NFR-011).
enum SyncOutboxEntityKind {
  favorite,
  playbackProgress,
  setting,
  source,
}

enum SyncOutboxOperation { upsert, delete }

final class SyncOutboxEntry {
  const SyncOutboxEntry({
    required this.id,
    required this.entityKind,
    required this.operation,
    required this.entityId,
    required this.payloadJson,
    required this.enqueuedAt,
    this.attempts = 0,
  });

  final String id;
  final SyncOutboxEntityKind entityKind;
  final SyncOutboxOperation operation;
  final String entityId;

  /// Opaque JSON body for the adapter — must not include secrets.
  final String payloadJson;
  final DateTime enqueuedAt;
  final int attempts;

  SyncOutboxEntry copyWith({int? attempts}) {
    return SyncOutboxEntry(
      id: id,
      entityKind: entityKind,
      operation: operation,
      entityId: entityId,
      payloadJson: payloadJson,
      enqueuedAt: enqueuedAt,
      attempts: attempts ?? this.attempts,
    );
  }
}
