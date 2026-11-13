import 'package:flutter/painting.dart';

/// Port over Flutter's process-wide [ImageCache] (TV-012).
///
/// Lets tests inject a memory fake without touching [PaintingBinding].
abstract interface class ImageCacheController {
  int get maximumSize;
  set maximumSize(int value);

  int get maximumSizeBytes;
  set maximumSizeBytes(int value);

  int get currentSize;
  int get currentSizeBytes;

  /// Drops keep-alive handles so off-screen list tiles can be GC'd.
  void clearLiveImages();

  /// Evicts the entire decoded cache.
  void clear();
}

/// Production adapter — [PaintingBinding.instance.imageCache].
final class FlutterImageCacheController implements ImageCacheController {
  ImageCache get _cache => PaintingBinding.instance.imageCache;

  @override
  int get maximumSize => _cache.maximumSize;

  @override
  set maximumSize(int value) => _cache.maximumSize = value;

  @override
  int get maximumSizeBytes => _cache.maximumSizeBytes;

  @override
  set maximumSizeBytes(int value) => _cache.maximumSizeBytes = value;

  @override
  int get currentSize => _cache.currentSize;

  @override
  int get currentSizeBytes => _cache.currentSizeBytes;

  @override
  void clearLiveImages() => _cache.clearLiveImages();

  @override
  void clear() => _cache.clear();
}

/// Deterministic fake for unit tests.
final class MemoryImageCacheController implements ImageCacheController {
  MemoryImageCacheController({
    this.maximumSize = 1000,
    this.maximumSizeBytes = 100 * 1024 * 1024,
  });

  @override
  int maximumSize;

  @override
  int maximumSizeBytes;

  @override
  int currentSize = 0;

  @override
  int currentSizeBytes = 0;

  int clearLiveCalls = 0;
  int clearCalls = 0;

  @override
  void clearLiveImages() {
    clearLiveCalls += 1;
    currentSize = 0;
    currentSizeBytes = 0;
  }

  @override
  void clear() {
    clearCalls += 1;
    currentSize = 0;
    currentSizeBytes = 0;
  }
}
