/// Ordered TV onboarding / auth steps (DSN-031).
enum TvOnboardingAuthStep {
  registerLogin,
  preferences,
  addSource,
  validationResult,
  continueLater,
}

/// Locked copy for [TvOnboardingAuthStep] — DoD wording only.
abstract final class TvOnboardingAuthCopy {
  static String titleFor(TvOnboardingAuthStep step) {
    switch (step) {
      case TvOnboardingAuthStep.registerLogin:
        return 'Register / Login';
      case TvOnboardingAuthStep.preferences:
        return 'Preferences';
      case TvOnboardingAuthStep.addSource:
        return 'Add source';
      case TvOnboardingAuthStep.validationResult:
        return 'Validation result';
      case TvOnboardingAuthStep.continueLater:
        return 'Continue later';
    }
  }

  static String bodyFor(TvOnboardingAuthStep step) {
    switch (step) {
      case TvOnboardingAuthStep.registerLogin:
        return 'Sign in with email and password. Receive text from the Companion when typing is easier on your phone.';
      case TvOnboardingAuthStep.preferences:
        return 'Set basics now, or skip and continue later.';
      case TvOnboardingAuthStep.addSource:
        return 'Add an M3U or Xtream source URL. Validate before continuing.';
      case TvOnboardingAuthStep.validationResult:
        return 'See whether the source validated. Retry or continue.';
      case TvOnboardingAuthStep.continueLater:
        return 'Leave onboarding and return when you are ready.';
    }
  }

  static const String continueLaterLabel = 'Continue later';
  static const String continueLabel = 'Continue';
  static const String loginLabel = 'Log in';
  static const String registerLabel = 'Register';
  static const String validateLabel = 'Validate';
  static const String retryLabel = 'Retry';
  static const String emailLabel = 'Email';
  static const String passwordLabel = 'Password';
  static const String sourceUrlLabel = 'Source URL';
  static const String validationOkTitle = 'Source validated';
  static const String validationFailTitle = 'Validation failed';
}
