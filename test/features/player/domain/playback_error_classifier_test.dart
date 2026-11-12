import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/features/player/domain/entities/playback_error.dart';
import 'package:mi_iptv/features/player/domain/services/playback_error_classifier.dart';

void main() {
  group('PlaybackErrorClassifier TV-054', () {
    test('classifies network source and decoder Media3 codes', () {
      final network = PlaybackErrorClassifier.classify(
        'ERROR_CODE_IO_NETWORK_CONNECTION_FAILED',
        position: const Duration(seconds: 12),
        streamHost: 'cdn.example',
      );
      expect(network.kind, PlaybackErrorKind.network);
      expect(network.retryable, isTrue);
      expect(network.userMessage, contains('Connection lost'));
      expect(network.position, const Duration(seconds: 12));
      expect(network.streamHost, 'cdn.example');

      final source = PlaybackErrorClassifier.classify(
        'ERROR_CODE_PARSING_MANIFEST_MALFORMED',
      );
      expect(source.kind, PlaybackErrorKind.source);
      expect(source.retryable, isTrue);

      final decoder = PlaybackErrorClassifier.classify(
        'ERROR_CODE_DECODER_INIT_FAILED',
      );
      expect(decoder.kind, PlaybackErrorKind.decoder);
      expect(decoder.retryable, isFalse);
      expect(decoder.userMessage, contains("couldn't play"));
    });

    test('unknown codes stay retryable with simple copy', () {
      final error = PlaybackErrorClassifier.classify('SOMETHING_ODD');
      expect(error.kind, PlaybackErrorKind.unknown);
      expect(error.retryable, isTrue);
      expect(error.userMessage, isNot(contains('SOMETHING_ODD')));
    });
  });
}
