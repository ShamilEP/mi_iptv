import '../entities/playback_error.dart';

/// Maps Media3 / channel error tokens onto [PlaybackError] (TV-054).
abstract final class PlaybackErrorClassifier {
  static const String _networkMsg = 'Connection lost. Reconnecting…';
  static const String _sourceMsg = "This stream isn't available right now.";
  static const String _decoderMsg = "This device couldn't play this stream.";
  static const String _unknownMsg = 'Playback failed. Retrying…';

  /// [code] is typically Media3 `errorCodeName` or a channel error code.
  static PlaybackError classify(
    String? code, {
    Duration position = Duration.zero,
    String? streamHost,
  }) {
    final token = (code ?? '').trim();
    final upper = token.toUpperCase();
    final kind = _kindOf(upper);
    return PlaybackError(
      kind: kind,
      code: token.isEmpty ? 'UNKNOWN' : token,
      userMessage: _messageOf(kind),
      retryable: _retryableOf(kind),
      position: position.isNegative ? Duration.zero : position,
      streamHost: streamHost,
    );
  }

  static PlaybackErrorKind _kindOf(String upper) {
    if (upper.isEmpty) return PlaybackErrorKind.unknown;

    if (upper.contains('DECODER') ||
        upper.contains('DECODING') ||
        upper.contains('RENDERER') ||
        upper.contains('DRM_DEVICE') ||
        upper.contains('AUDIO_TRACK') ||
        upper.contains('VIDEO_FRAME')) {
      return PlaybackErrorKind.decoder;
    }

    if (upper.contains('NETWORK') ||
        upper.contains('TIMEOUT') ||
        upper.contains('DNS') ||
        upper.contains('HOST_UNRESOLVED') ||
        upper.contains('CONNECTION') ||
        upper.contains('IO_NETWORK')) {
      return PlaybackErrorKind.network;
    }

    if (upper.contains('HTTP') ||
        upper.contains('FILE_NOT_FOUND') ||
        upper.contains('NO_PERMISSION') ||
        upper.contains('CLEARTEXT') ||
        upper.contains('PARSING') ||
        upper.contains('MANIFEST') ||
        upper.contains('CONTAINER') ||
        upper.contains('UNSUPPORTED') ||
        upper.contains('IO_BAD') ||
        upper.contains('IO_INVALID') ||
        upper.contains('IO_READ') ||
        upper.contains('SOURCE') ||
        upper.contains('DRM_')) {
      return PlaybackErrorKind.source;
    }

    if (upper.contains('IO_')) {
      return PlaybackErrorKind.network;
    }

    return PlaybackErrorKind.unknown;
  }

  static String _messageOf(PlaybackErrorKind kind) {
    return switch (kind) {
      PlaybackErrorKind.network => _networkMsg,
      PlaybackErrorKind.source => _sourceMsg,
      PlaybackErrorKind.decoder => _decoderMsg,
      PlaybackErrorKind.unknown => _unknownMsg,
    };
  }

  static bool _retryableOf(PlaybackErrorKind kind) {
    return switch (kind) {
      PlaybackErrorKind.network => true,
      PlaybackErrorKind.source => true,
      PlaybackErrorKind.unknown => true,
      PlaybackErrorKind.decoder => false,
    };
  }
}
