import 'package:flutter/material.dart';

import '../../../../core/platform/companion_platform.dart';
import '../../../../core/platform/companion_platform_conventions.dart';
import '../../../../core/platform/companion_platform_shell.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/brand_lockup.dart';
import '../../../../core/widgets/control_chrome.dart';
import '../../../../core/widgets/mi_button.dart';
import '../../../../core/widgets/mi_text_field.dart';

/// Gallery of companion iOS / Android design conventions (DSN-054).
///
/// Shows navigation, safe areas, system keyboard, and haptics for the selected
/// platform. Design shell only — no routing or plugin side effects beyond
/// Flutter [HapticFeedback].
class CompanionPlatformConventionsPage extends StatefulWidget {
  const CompanionPlatformConventionsPage({
    super.key,
    this.initialPlatform = CompanionPlatform.android,
    this.onHaptic,
  });

  final CompanionPlatform initialPlatform;

  /// Test double for impact haptic presses.
  final Future<void> Function()? onHaptic;

  static const String title = 'Platform conventions';
  static const String body =
      'Navigation, safe areas, system keyboard, and haptics per host OS.';

  @override
  State<CompanionPlatformConventionsPage> createState() =>
      _CompanionPlatformConventionsPageState();
}

class _CompanionPlatformConventionsPageState
    extends State<CompanionPlatformConventionsPage> {
  late CompanionPlatform _platform = widget.initialPlatform;
  final TextEditingController _sampleField = TextEditingController();
  String _hapticFeedback = 'Ready';
  var _backTaps = 0;

  @override
  void dispose() {
    _sampleField.dispose();
    super.dispose();
  }

  CompanionPlatformConventions get _conventions =>
      CompanionPlatformConventions.of(_platform);

  void _selectPlatform(CompanionPlatform platform) {
    setState(() {
      _platform = platform;
      _hapticFeedback = 'Selection';
    });
    CompanionPlatformConventions.of(platform).selectionFeedback();
  }

  void _fireImpact() {
    final runner = widget.onHaptic ?? _conventions.impactFeedback;
    runner();
    setState(() => _hapticFeedback = _conventions.hapticsTitle);
  }

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final textTheme = Theme.of(context).textTheme;
    final conventions = _conventions;

    return CompanionPlatformShell(
      platform: _platform,
      onBack: () => setState(() => _backTaps++),
      child: ListView(
        children: [
          const BrandLockup(
            markHeight: AppSpacing.xl,
            tone: BrandMarkTone.companion,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            CompanionPlatformConventionsPage.title,
            style: textTheme.headlineMedium?.copyWith(color: brand.ink),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            CompanionPlatformConventionsPage.body,
            style: textTheme.bodyLarge?.copyWith(color: brand.muted),
          ),
          if (_backTaps > 0) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Back pressed',
              key: const ValueKey<String>('platform-back-pressed'),
              style: textTheme.labelLarge?.copyWith(color: brand.primary),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Host',
            style: textTheme.labelLarge?.copyWith(color: brand.muted),
          ),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final platform in CompanionPlatform.values)
                MiButton(
                  label: platform == CompanionPlatform.android
                      ? 'Android'
                      : 'iOS',
                  emphasis: _platform == platform
                      ? ControlEmphasis.primary
                      : ControlEmphasis.secondary,
                  onPressed: () => _selectPlatform(platform),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _ConventionCard(
            title: conventions.navigationTitle,
            body: conventions.navigationBody,
            cue: conventions.backAffordanceLabel,
          ),
          const SizedBox(height: AppSpacing.md),
          _ConventionCard(
            title: conventions.safeAreaTitle,
            body: conventions.safeAreaBody,
            cue: 'SafeArea',
          ),
          const SizedBox(height: AppSpacing.md),
          _ConventionCard(
            title: conventions.keyboardTitle,
            body: conventions.keyboardBody,
            cue: 'System IME',
          ),
          const SizedBox(height: AppSpacing.sm),
          MiTextField(
            controller: _sampleField,
            label: 'Sample field',
            hint: 'Type with the system keyboard',
            keyboardType: TextInputType.text,
          ),
          const SizedBox(height: AppSpacing.md),
          _ConventionCard(
            title: conventions.hapticsTitle,
            body: conventions.hapticsBody,
            cue: _hapticFeedback,
          ),
          const SizedBox(height: AppSpacing.sm),
          MiButton(
            label: 'Try haptic',
            onPressed: _fireImpact,
          ),
        ],
      ),
    );
  }
}

class _ConventionCard extends StatelessWidget {
  const _ConventionCard({
    required this.title,
    required this.body,
    required this.cue,
  });

  final String title;
  final String body;
  final String cue;

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final textTheme = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: brand.cloud,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: brand.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.insetCard),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: textTheme.titleLarge?.copyWith(color: brand.ink),
                  ),
                ),
                Text(
                  cue,
                  style: textTheme.labelLarge?.copyWith(color: brand.primary),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              body,
              style: textTheme.bodyLarge?.copyWith(color: brand.muted),
            ),
          ],
        ),
      ),
    );
  }
}
