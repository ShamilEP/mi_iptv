/// Playback error taxonomy for Media3 / IPTV (TV-054 / NFR-QOE-05 / FR-016).
enum PlaybackErrorKind {
  /// Connectivity / timeout / DNS style failures — usually retryable.
  network,

  /// Manifest / HTTP / URL / container content failures.
  source,

  /// Decoder / renderer / format unsupported on device.
  decoder,

  /// Unclassified platform code.
  unknown,
}

/// Classified playback failure with user-safe copy (no raw codes as primary UX).
final class PlaybackError {
  const PlaybackError({
    required this.kind,
    required this.code,
    required this.userMessage,
    required this.retryable,
    this.position = Duration.zero,
    this.streamHost,
  });

  final PlaybackErrorKind kind;

  /// Machine code (e.g. Media3 `ERROR_CODE_IO_*`) — not shown as primary UI.
  final String code;

  /// Simple viewer-facing status (FR-016).
  final String userMessage;

  /// Whether [PlaybackRetryPolicy] may schedule another attempt.
  final bool retryable;

  /// Playback position when the error occurred (context to preserve).
  final Duration position;

  /// Host only — never a credential-bearing full URI.
  final String? streamHost;
}
