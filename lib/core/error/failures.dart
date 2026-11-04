/// Domain-level failure hierarchy. Map transport/plugin errors in adapters.
sealed class Failure {
  const Failure(this.message);
  final String message;
}

final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network unavailable']);
}

final class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failed']);
}

final class SyncFailure extends Failure {
  const SyncFailure([super.message = 'Sync failed']);
}

final class PlaybackFailure extends Failure {
  const PlaybackFailure([super.message = 'Playback failed']);
}

final class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'Unexpected error']);
}
