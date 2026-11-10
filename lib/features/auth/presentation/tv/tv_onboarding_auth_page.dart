import 'package:flutter/material.dart';

import '../../../../core/accessibility/tv_accessibility.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/brand_lockup.dart';
import '../../../../core/widgets/control_chrome.dart';
import '../../../../core/widgets/mi_button.dart';
import '../../../../core/widgets/type_from_phone_hint.dart';
import 'tv_onboarding_auth_panels.dart';
import 'tv_onboarding_auth_step.dart';

/// TV Onboarding + Auth hi-fi flow shell (DSN-031).
///
/// Short steps: register/login → preferences → add source → validation result,
/// with a global **Continue later** escape and Companion text-entry hint.
class TvOnboardingAuthPage extends StatefulWidget {
  const TvOnboardingAuthPage({
    super.key,
    this.initialStep = TvOnboardingAuthStep.registerLogin,
    this.onContinueLater,
  });

  final TvOnboardingAuthStep initialStep;
  final VoidCallback? onContinueLater;

  @override
  State<TvOnboardingAuthPage> createState() => _TvOnboardingAuthPageState();
}

class _TvOnboardingAuthPageState extends State<TvOnboardingAuthPage> {
  late TvOnboardingAuthStep _step = widget.initialStep;
  bool _sourceValid = false;

  void _go(TvOnboardingAuthStep step) => setState(() => _step = step);

  void _onValidated({required bool ok}) {
    setState(() {
      _sourceValid = ok;
      _step = TvOnboardingAuthStep.validationResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final steps = TvOnboardingAuthStep.values;
    final index = steps.indexOf(_step);

    return TvAccessibleScope(
      child: Scaffold(
      backgroundColor: brand.ink,
      body: Padding(
        padding: AppOverscan.padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const BrandLockup(markHeight: 48),
                const Spacer(),
                Flexible(
                  child: Text(
                    'Step ${index + 1} of ${steps.length}',
                    textAlign: TextAlign.end,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: brand.mist,
                        ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                MiButton(
                  label: TvOnboardingAuthCopy.continueLaterLabel,
                  emphasis: ControlEmphasis.secondary,
                  onPressed: () {
                    _go(TvOnboardingAuthStep.continueLater);
                    widget.onContinueLater?.call();
                  },
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.stack),
            Text(
              TvOnboardingAuthCopy.titleFor(_step),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: brand.cloud,
                  ),
            ),
            const SizedBox(height: AppSpacing.stackTight),
            Text(
              TvOnboardingAuthCopy.bodyFor(_step),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: brand.mist,
                  ),
            ),
            const SizedBox(height: AppSpacing.xs),
            const TypeFromPhoneHint(),
            const SizedBox(height: AppSpacing.stack),
            Expanded(
              child: SingleChildScrollView(
                child: TvOnboardingAuthPanels(
                step: _step,
                sourceValid: _sourceValid,
                onContinue: () {
                  final next = index + 1;
                  if (next < steps.length) {
                    _go(steps[next]);
                  }
                },
                onValidated: _onValidated,
                onRetrySource: () => _go(TvOnboardingAuthStep.addSource),
                onBackToLogin: () => _go(TvOnboardingAuthStep.registerLogin),
              ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
