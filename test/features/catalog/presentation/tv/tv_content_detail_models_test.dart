import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/features/catalog/presentation/tv/tv_content_detail_models.dart';

void main() {
  group('QA-019 / FR-013 showsResume', () {
    TvContentDetail detail({double? progress}) {
      return TvContentDetail(
        id: 'vod-1',
        title: 'Harbor Lights',
        synopsis: 'A night on the pier.',
        metadata: const <String>['2024', 'Drama'],
        durationLabel: '1h 40m',
        progress: progress,
      );
    }

    test('hides Resume below 15% and when complete or missing', () {
      expect(detail().showsResume, isFalse);
      expect(detail(progress: 0.14).showsResume, isFalse);
      expect(detail(progress: 1.0).showsResume, isFalse);
    });

    test('shows Resume at the 15% Continue watching threshold', () {
      expect(detail(progress: 0.15).showsResume, isTrue);
      expect(detail(progress: 0.85).showsResume, isTrue);
    });
  });
}
