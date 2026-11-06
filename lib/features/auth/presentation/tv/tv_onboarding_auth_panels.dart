import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/control_chrome.dart';
import '../../../../core/widgets/mi_button.dart';
import '../../../../core/widgets/mi_text_field.dart';
import '../../../../core/widgets/status_pattern.dart';
import '../../../../core/widgets/status_pattern_copy.dart';
import '../../../../core/widgets/tv_on_screen_keyboard.dart';
import 'tv_onboarding_auth_step.dart';

/// Step bodies for [TvOnboardingAuthPage] (DSN-031).
class TvOnboardingAuthPanels extends StatelessWidget {
  const TvOnboardingAuthPanels({
    super.key,
    required this.step,
    required this.sourceValid,
    required this.onContinue,
    required this.onValidated,
    required this.onRetrySource,
    required this.onBackToLogin,
  });

  final TvOnboardingAuthStep step;
  final bool sourceValid;
  final VoidCallback onContinue;
  final void Function({required bool ok}) onValidated;
  final VoidCallback onRetrySource;
  final VoidCallback onBackToLogin;

  @override
  Widget build(BuildContext context) {
    switch (step) {
      case TvOnboardingAuthStep.registerLogin:
        return const _RegisterLoginPanel();
      case TvOnboardingAuthStep.preferences:
        return _PreferencesPanel(onContinue: onContinue);
      case TvOnboardingAuthStep.addSource:
        return _AddSourcePanel(onValidated: onValidated);
      case TvOnboardingAuthStep.validationResult:
        return _ValidationResultPanel(
          ok: sourceValid,
          onContinue: onContinue,
          onRetry: onRetrySource,
        );
      case TvOnboardingAuthStep.continueLater:
        return _ContinueLaterPanel(onBackToLogin: onBackToLogin);
    }
  }
}

class _RegisterLoginPanel extends StatefulWidget {
  const _RegisterLoginPanel();

  @override
  State<_RegisterLoginPanel> createState() => _RegisterLoginPanelState();
}

class _RegisterLoginPanelState extends State<_RegisterLoginPanel> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _passwordMode = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TvOnScreenKeyboard(
          key: ValueKey<bool>(_passwordMode),
          controller: _passwordMode ? _password : _email,
          fieldLabel: _passwordMode
              ? TvOnboardingAuthCopy.passwordLabel
              : TvOnboardingAuthCopy.emailLabel,
          hint: _passwordMode ? null : 'you@example.com',
          obscureText: _passwordMode,
          showTypeFromPhoneHint: true,
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.sm,
          children: [
            MiButton(
              label: _passwordMode ? 'Edit email' : 'Edit password',
              emphasis: ControlEmphasis.secondary,
              onPressed: () => setState(() => _passwordMode = !_passwordMode),
            ),
            MiButton(
              label: TvOnboardingAuthCopy.loginLabel,
              onPressed: () {},
            ),
            MiButton(
              label: TvOnboardingAuthCopy.registerLabel,
              emphasis: ControlEmphasis.secondary,
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}

class _PreferencesPanel extends StatelessWidget {
  const _PreferencesPanel({required this.onContinue});

  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Preferences stay minimal in MVP — continue when ready.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: brand.cloud,
              ),
        ),
        const SizedBox(height: AppSpacing.stack),
        MiButton(
          label: TvOnboardingAuthCopy.continueLabel,
          onPressed: onContinue,
        ),
      ],
    );
  }
}

class _AddSourcePanel extends StatefulWidget {
  const _AddSourcePanel({required this.onValidated});

  final void Function({required bool ok}) onValidated;

  @override
  State<_AddSourcePanel> createState() => _AddSourcePanelState();
}

class _AddSourcePanelState extends State<_AddSourcePanel> {
  final _url = TextEditingController();

  @override
  void dispose() {
    _url.dispose();
    super.dispose();
  }

  bool _looksValid(String raw) {
    final value = MiTextField.sanitize(raw).trim();
    final uri = Uri.tryParse(value);
    return uri != null &&
        uri.hasScheme &&
        uri.isScheme('https') &&
        uri.host.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TvOnScreenKeyboard(
          controller: _url,
          fieldLabel: TvOnboardingAuthCopy.sourceUrlLabel,
          hint: 'https://…',
          showTypeFromPhoneHint: true,
        ),
        const SizedBox(height: AppSpacing.md),
        MiButton(
          label: TvOnboardingAuthCopy.validateLabel,
          onPressed: () => widget.onValidated(ok: _looksValid(_url.text)),
        ),
      ],
    );
  }
}

class _ValidationResultPanel extends StatelessWidget {
  const _ValidationResultPanel({
    required this.ok,
    required this.onContinue,
    required this.onRetry,
  });

  final bool ok;
  final VoidCallback onContinue;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    if (!ok) {
      return ErrorPattern(
        copy: const StatusPatternCopy(
          title: TvOnboardingAuthCopy.validationFailTitle,
          message: 'Check the URL and try again, or continue later.',
          actionLabel: TvOnboardingAuthCopy.retryLabel,
        ),
        onAction: onRetry,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check_circle_outline, color: brand.success, size: 48),
        const SizedBox(height: AppSpacing.md),
        Text(
          TvOnboardingAuthCopy.validationOkTitle,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: brand.cloud,
              ),
        ),
        const SizedBox(height: AppSpacing.stackTight),
        Text(
          'Your source URL looks valid. Continue onboarding.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: brand.mist,
              ),
        ),
        const SizedBox(height: AppSpacing.stack),
        MiButton(
          label: TvOnboardingAuthCopy.continueLabel,
          onPressed: onContinue,
        ),
      ],
    );
  }
}

class _ContinueLaterPanel extends StatelessWidget {
  const _ContinueLaterPanel({required this.onBackToLogin});

  final VoidCallback onBackToLogin;

  @override
  Widget build(BuildContext context) {
    return EmptyPattern(
      copy: const StatusPatternCopy(
        title: TvOnboardingAuthCopy.continueLaterLabel,
        message:
            'You can finish register/login, preferences, and sources anytime.',
        actionLabel: TvOnboardingAuthCopy.loginLabel,
      ),
      onAction: onBackToLogin,
    );
  }
}
