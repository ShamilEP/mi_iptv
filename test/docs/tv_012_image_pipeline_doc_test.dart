import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('TV-012 doc locks loader config, thumbnails, release, skeletons', () {
    final file = File('docs/architecture/tv-012-image-pipeline.md');
    expect(file.existsSync(), isTrue);
    final text = file.readAsStringSync();
    expect(text, contains('TV-012'));
    expect(text, contains('NFR-003'));
    expect(text, contains('ImagePipeline'));
    expect(text, contains('ImagePipelineConfig'));
    expect(text, contains('thumbnail'));
    expect(text, contains('releaseOffscreenImages'));
    expect(text, contains('ContentCardSkeleton'));
    expect(text, contains('ManagedNetworkImage'));
    expect(text, contains('cached_network_image'));
    expect(text, contains('HTTPS'));
  });
}
