import 'package:flutter/material.dart';

import '../../../../core/platform/companion_platform.dart';
import '../../../../core/platform/companion_platform_shell.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/brand_lockup.dart';
import '../../../../core/widgets/control_chrome.dart';
import '../../../../core/widgets/mi_button.dart';
import '../../../../core/widgets/mi_text_field.dart';
import '../parental_pin_digits_row.dart';
import '../parental_pin_models.dart';

/// Companion parental PIN design shell (DSN-062).
///
/// System keyboard numeric entry for the parental PIN, plus the same
/// restricted-content messaging as TV.
class CompanionParentalPinPage extends StatefulWidget {
  const CompanionParentalPinPage({
    super.key,
    this.initialScreen = ParentalPinScreen.restricted,
    this.expectedPin = ParentalPinCopy.demoExpectedPin,
    this.platform = CompanionPlatform.android,
    this.onUnlocked,
    this.onBack,
  });

  final ParentalPinScreen initialScreen;
  final String expectedPin;
  final CompanionPlatform platform;
  final VoidCallback? onUnlocked;
  final VoidCallback? onBack;

  @override
  State<CompanionParentalPinPage> createState() =>
      _CompanionParentalPinPageState();
}

class _CompanionParentalPinPageState extends State<CompanionParentalPinPage> {
  late ParentalPinScreen _screen = widget.initialScreen;
  final TextEditingController _pin = TextEditingController();
  ParentalPinDigits _digits = const ParentalPinDigits('');
  bool _wrong = false;

  @override
  void dispose() {
    _pin.dispose();
    super.dispose();
  }

  void _go(ParentalPinScreen screen) {
    setState(() {
      _screen = screen;
      _digits = const ParentalPinDigits('');
      _pin.clear();
      _wrong = false;
    });
  }

  void _onPinChanged(String raw) {
    final sanitized = MiTextField.sanitize(raw).replaceAll(RegExp(r'\D'), '');
    final clipped = sanitized.length > ParentalPinCopy.pinLength
        ? sanitized.substring(0, ParentalPinCopy.pinLength)
        : sanitized;
    if (_pin.text != clipped) {
      _pin.value = TextEditingValue(
        text: clipped,
        selection: TextSelection.collapsed(offset: clipped.length),
      );
    }
    setState(() {
      _wrong = false;
      _digits = ParentalPinDigits(clipped);
    });
    if (clipped.length == ParentalPinCopy.pinLength) {
      _submit(clipped);
    }
  }

  void _submit([String? value]) {
    final pin = value ?? _digits.value;
    if (pin == widget.expectedPin) {
      setState(() {
        _wrong = false;
        _screen = ParentalPinScreen.unlocked;
      });
      widget.onUnlocked?.call();
      return;
    }
    setState(() {
      _wrong = true;
      _digits = const ParentalPinDigits('');
      _pin.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final textTheme = Theme.of(context).textTheme;

    return CompanionPlatformShell(
      platform: widget.platform,
      onBack: widget.onBack ?? () => _go(ParentalPinScreen.restricted),
      backgroundColor: brand.cloud,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BrandLockup(
            markHeight: AppSpacing.xl,
            tone: BrandMarkTone.companion,
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(child: _body(brand, textTheme)),
        ],
      ),
    );
  }

  Widget _body(MiBrandColors brand, TextTheme textTheme) {
    switch (_screen) {
      case ParentalPinScreen.restricted:
        return ListView(
          children: [
            Icon(
              Icons.lock_outline,
              color: brand.warning,
              size: AppSpacing.xxl,
              semanticLabel: ParentalPinCopy.restrictedTitle,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              ParentalPinCopy.restrictedTitle,
              style: textTheme.headlineSmall?.copyWith(color: brand.ink),
            ),
            const SizedBox(height: AppSpacing.stackTight),
            Text(
              ParentalPinCopy.restrictedMessage,
              style: textTheme.bodyLarge?.copyWith(color: brand.muted),
            ),
            const SizedBox(height: AppSpacing.xl),
            MiButton(
              key: const ValueKey<String>('companion-pin-enter'),
              label: ParentalPinCopy.enterPinAction,
              onPressed: () => _go(ParentalPinScreen.entry),
            ),
          ],
        );
      case ParentalPinScreen.entry:
        return ListView(
          children: [
            Text(
              ParentalPinCopy.entryTitle,
              style: textTheme.headlineSmall?.copyWith(color: brand.ink),
            ),
            const SizedBox(height: AppSpacing.stackTight),
            Text(
              ParentalPinCopy.entrySubtitle,
              style: textTheme.bodyLarge?.copyWith(color: brand.muted),
            ),
            const SizedBox(height: AppSpacing.lg),
            ParentalPinDigitsRow(digits: _digits, error: _wrong),
            if (_wrong) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                ParentalPinCopy.wrongPinMessage,
                style: textTheme.bodyMedium?.copyWith(color: brand.error),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            MiTextField(
              key: const ValueKey<String>('companion-pin-field'),
              controller: _pin,
              label: ParentalPinCopy.pinLabel,
              hint: ParentalPinCopy.pinHint,
              obscureText: true,
              keyboardType: TextInputType.number,
              onChanged: _onPinChanged,
            ),
            // Hide raw digits from accessibility when obscured field is used
            // alongside the slot row; length is already announced by the row.
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                MiButton(
                  key: const ValueKey<String>('companion-pin-submit'),
                  label: ParentalPinCopy.submitLabel,
                  onPressed: _submit,
                ),
                const SizedBox(width: AppSpacing.md),
                MiButton(
                  key: const ValueKey<String>('companion-pin-cancel'),
                  label: ParentalPinCopy.cancelLabel,
                  emphasis: ControlEmphasis.secondary,
                  onPressed: () => _go(ParentalPinScreen.restricted),
                ),
              ],
            ),
          ],
        );
      case ParentalPinScreen.unlocked:
        return ListView(
          children: [
            Icon(
              Icons.lock_open,
              color: brand.success,
              size: AppSpacing.xxl,
              semanticLabel: ParentalPinCopy.unlockedTitle,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              ParentalPinCopy.unlockedTitle,
              style: textTheme.headlineSmall?.copyWith(color: brand.ink),
            ),
            const SizedBox(height: AppSpacing.stackTight),
            Text(
              ParentalPinCopy.unlockedMessage,
              style: textTheme.bodyLarge?.copyWith(color: brand.muted),
            ),
            const SizedBox(height: AppSpacing.xl),
            MiButton(
              key: const ValueKey<String>('companion-pin-continue'),
              label: ParentalPinCopy.continueLabel,
              onPressed: widget.onUnlocked,
            ),
          ],
        );
    }
  }
}
