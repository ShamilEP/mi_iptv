/// Shared copy and demo fixture for DSN-071 pairing-code shells.
enum PairingCodeScreen { showCode, linked, entry }

abstract final class PairingCodeCopy {
  static const int codeLength = 6;

  /// Design-shell expected code only — never log or persist as a secret.
  static const String demoExpectedCode = '482913';

  static const String tvTitle = 'Link your phone';
  static const String tvBody =
      'Open Mi IPTV Companion and enter this code to control this TV.';
  static const String tvWaiting = 'Waiting for Companion…';
  static const String tvRefresh = 'Refresh code';
  static const String tvLinkedTitle = 'Phone linked';
  static const String tvLinkedBody =
      'This TV is ready for remote and send-to-TV from Companion.';

  static const String companionTitle = 'Enter TV code';
  static const String companionBody =
      'Type the 6-digit code shown on your TV screen.';
  static const String companionFieldLabel = 'Pairing code';
  static const String companionSubmit = 'Link TV';
  static const String companionCancel = 'Cancel';
  static const String companionWrong =
      'That code does not match. Check the TV and try again.';
  static const String companionLinkedTitle = 'TV linked';
  static const String companionLinkedBody =
      'You can use the remote and send titles to this TV.';

  /// Formats `482913` → `482 913` for TV display.
  static String formatDisplay(String raw) {
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    if (digits.length <= 3) return digits;
    return '${digits.substring(0, 3)} ${digits.substring(3)}';
  }
}
