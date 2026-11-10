/// Controls on the companion remote (DSN-051).
enum CompanionRemoteCommand {
  up,
  down,
  left,
  right,
  ok,
  back,
  home,
  volumeUp,
  volumeDown,
  mute,
  play,
  pause,
  seekBack,
  seekForward,
}

/// Locked labels for [CompanionRemoteCommand].
abstract final class CompanionRemoteCopy {
  static const String title = 'Remote';
  static const String ready = 'Ready';
  static const String keyboardLabel = 'Keyboard';
  static const String keyboardHint = 'Type for the TV';
  static const String sendLabel = 'Send';
  static const String emptyKeyboardMessage = 'Enter text to send.';
  static const String demoTvName = 'Living room';

  static String labelFor(CompanionRemoteCommand command) {
    switch (command) {
      case CompanionRemoteCommand.up:
        return 'Up';
      case CompanionRemoteCommand.down:
        return 'Down';
      case CompanionRemoteCommand.left:
        return 'Left';
      case CompanionRemoteCommand.right:
        return 'Right';
      case CompanionRemoteCommand.ok:
        return 'OK';
      case CompanionRemoteCommand.back:
        return 'Back';
      case CompanionRemoteCommand.home:
        return 'Home';
      case CompanionRemoteCommand.volumeUp:
        return 'Volume up';
      case CompanionRemoteCommand.volumeDown:
        return 'Volume down';
      case CompanionRemoteCommand.mute:
        return 'Mute';
      case CompanionRemoteCommand.play:
        return 'Play';
      case CompanionRemoteCommand.pause:
        return 'Pause';
      case CompanionRemoteCommand.seekBack:
        return 'Back 10 seconds';
      case CompanionRemoteCommand.seekForward:
        return 'Forward 10 seconds';
    }
  }
}
