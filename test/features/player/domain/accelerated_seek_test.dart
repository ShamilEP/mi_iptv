import 'package:flutter_test/flutter_test.dart';
import 'package:mi_iptv/features/player/domain/services/accelerated_seek.dart';

void main() {
  test('AcceleratedSeek steps grow with hold time', () {
    expect(AcceleratedSeek.tapStep, const Duration(seconds: 10));
    expect(
      AcceleratedSeek.stepForHoldElapsed(Duration.zero),
      const Duration(seconds: 10),
    );
    expect(
      AcceleratedSeek.stepForHoldElapsed(const Duration(seconds: 2)),
      const Duration(seconds: 30),
    );
    expect(
      AcceleratedSeek.stepForHoldElapsed(const Duration(seconds: 4)),
      const Duration(seconds: 60),
    );
    expect(
      AcceleratedSeek.stepForHoldElapsed(const Duration(seconds: 8)),
      const Duration(minutes: 5),
    );
  });
}
