import 'package:flutter/foundation.dart';

/// Parental PIN shell screens (DSN-062).
enum ParentalPinScreen {
  /// Restricted-content gate with messaging before PIN entry.
  restricted,

  /// Enter / confirm parental PIN.
  entry,

  /// PIN accepted — unlock messaging.
  unlocked,
}

/// Locked copy shared by TV and Companion parental PIN shells (DSN-062).
abstract final class ParentalPinCopy {
  static const String restrictedTitle = 'Restricted content';
  static const String restrictedMessage =
      'This title is locked for kid profiles. Ask a parent to enter the PIN.';
  static const String enterPinAction = 'Enter PIN';
  static const String askParentAction = 'Ask a parent';

  static const String entryTitle = 'Enter parental PIN';
  static const String entrySubtitle =
      'Unlock restricted titles for this profile.';
  static const String pinLabel = 'PIN';
  static const String pinHint = '4-digit PIN';
  static const String submitLabel = 'Unlock';
  static const String cancelLabel = 'Cancel';
  static const String clearLabel = 'Clear';
  static const String deleteLabel = 'Delete';
  static const String wrongPinMessage = 'That PIN is incorrect. Try again.';
  static const String unlockedTitle = 'Unlocked';
  static const String unlockedMessage =
      'Restricted content is available for this session.';
  static const String continueLabel = 'Continue';

  /// Demo expected PIN for the design shell only (not a real credential).
  static const String demoExpectedPin = '1234';
  static const int pinLength = 4;
}

/// Obscured PIN digit slots for TV / Companion chrome.
@immutable
class ParentalPinDigits {
  const ParentalPinDigits(this.value);

  final String value;

  int get length => value.length;
  bool get isComplete => value.length >= ParentalPinCopy.pinLength;

  ParentalPinDigits append(String digit) {
    if (isComplete || digit.isEmpty) return this;
    final next = '$value${digit[0]}';
    if (next.length > ParentalPinCopy.pinLength) {
      return ParentalPinDigits(next.substring(0, ParentalPinCopy.pinLength));
    }
    return ParentalPinDigits(next);
  }

  ParentalPinDigits delete() {
    if (value.isEmpty) return this;
    return ParentalPinDigits(value.substring(0, value.length - 1));
  }

  ParentalPinDigits clear() => const ParentalPinDigits('');
}
