/// OS / test source of inbound deep-link URIs (CMP-050).
abstract interface class DeepLinkIngress {
  /// Cold-start link, if any.
  Future<Uri?> initialLink();

  /// Warm-start / subsequent links while the app is running.
  Stream<Uri> get onLink;
}
