import '../entities/linked_tv_snapshot.dart';

/// Persists last-known linked TV status for offline Companion UX (CMP-006).
abstract interface class LinkedTvStatusStore {
  Future<LinkedTvSnapshot?> load();

  Future<void> save(LinkedTvSnapshot snapshot);

  Future<void> clear();
}
