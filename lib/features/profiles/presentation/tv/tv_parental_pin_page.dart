import 'package:flutter/material.dart';

import '../../../../core/accessibility/tv_accessibility.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/brand_lockup.dart';
import '../../../../core/widgets/control_chrome.dart';
import '../../../../core/widgets/mi_button.dart';
import '../../../../core/widgets/type_from_phone_hint.dart';
import '../parental_pin_digits_row.dart';
import '../parental_pin_models.dart';
import 'tv_pin_pad.dart';

/// TV parental PIN design shell (DSN-062).
///
/// Restricted-content messaging, D-pad numeric PIN entry, and unlock
/// confirmation. Demo PIN is [ParentalPinCopy.demoExpectedPin] only.
class TvParentalPinPage extends StatefulWidget {
  const TvParentalPinPage({
    super.key,
    this.initialScreen = ParentalPinScreen.restricted,
    this.expectedPin = ParentalPinCopy.demoExpectedPin,
    this.onUnlocked,
    this.onTypeFromPhone,
  });

  final ParentalPinScreen initialScreen;
  final String expectedPin;
  final VoidCallback? onUnlocked;
  final VoidCallback? onTypeFromPhone;

  @override
  State<TvParentalPinPage> createState() => _TvParentalPinPageState();
}

class _TvParentalPinPageState extends State<TvParentalPinPage> {
  late ParentalPinScreen _screen = widget.initialScreen;
  ParentalPinDigits _digits = const ParentalPinDigits('');
  bool _wrong = false;

  void _go(ParentalPinScreen screen) {
    setState(() {
      _screen = screen;
      _digits = const ParentalPinDigits('');
      _wrong = false;
    });
  }

  void _append(String digit) {
    setState(() {
      _wrong = false;
      _digits = _digits.append(digit);
    });
    if (_digits.isComplete) {
      _submit();
    }
  }

  void _submit() {
    if (_digits.value == widget.expectedPin) {
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
    });
  }

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final textTheme = Theme.of(context).textTheme;

    return TvAccessibleScope(
      child: Scaffold(
        backgroundColor: brand.ink,
        body: Padding(
          padding: AppOverscan.padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BrandLockup(markHeight: AppSpacing.xxl),
              const SizedBox(height: AppSpacing.md),
              Expanded(child: _body(brand, textTheme)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _body(MiBrandColors brand, TextTheme textTheme) {
    switch (_screen) {
      case ParentalPinScreen.restricted:
        return _RestrictedPanel(
          onEnterPin: () => _go(ParentalPinScreen.entry),
        );
      case ParentalPinScreen.entry:
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ParentalPinCopy.entryTitle,
                style: textTheme.headlineMedium?.copyWith(color: brand.cloud),
              ),
              const SizedBox(height: AppSpacing.stackTight),
              Text(
                ParentalPinCopy.entrySubtitle,
                style: textTheme.bodyLarge?.copyWith(color: brand.mist),
              ),
              const SizedBox(height: AppSpacing.sm),
              TypeFromPhoneHint(onPressed: widget.onTypeFromPhone),
              const SizedBox(height: AppSpacing.xl),
              Center(
                child: ParentalPinDigitsRow(digits: _digits, error: _wrong),
              ),
              if (_wrong) ...[
                const SizedBox(height: AppSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: brand.error,
                      size: AppSpacing.lg,
                      semanticLabel: ParentalPinCopy.wrongPinMessage,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Flexible(
                      child: Text(
                        ParentalPinCopy.wrongPinMessage,
                        style: textTheme.bodyMedium?.copyWith(
                          color: brand.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: AppSpacing.xl),
              Center(
                child: TvPinPad(
                  onDigit: _append,
                  onDelete: () => setState(() {
                    _wrong = false;
                    _digits = _digits.delete();
                  }),
                  onClear: () => setState(() {
                    _wrong = false;
                    _digits = _digits.clear();
                  }),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              MiButton(
                key: const ValueKey<String>('pin-cancel'),
                label: ParentalPinCopy.cancelLabel,
                emphasis: ControlEmphasis.secondary,
                onPressed: () => _go(ParentalPinScreen.restricted),
              ),
            ],
          ),
        );
      case ParentalPinScreen.unlocked:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
              style: textTheme.headlineMedium?.copyWith(color: brand.cloud),
            ),
            const SizedBox(height: AppSpacing.stackTight),
            Text(
              ParentalPinCopy.unlockedMessage,
              style: textTheme.bodyLarge?.copyWith(color: brand.mist),
            ),
            const SizedBox(height: AppSpacing.xl),
            MiButton(
              key: const ValueKey<String>('pin-continue'),
              label: ParentalPinCopy.continueLabel,
              onPressed: widget.onUnlocked,
            ),
          ],
        );
    }
  }
}

class _RestrictedPanel extends StatelessWidget {
  const _RestrictedPanel({required this.onEnterPin});

  final VoidCallback onEnterPin;

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
          style: textTheme.headlineMedium?.copyWith(color: brand.cloud),
        ),
        const SizedBox(height: AppSpacing.stackTight),
        Text(
          ParentalPinCopy.restrictedMessage,
          style: textTheme.bodyLarge?.copyWith(color: brand.mist),
        ),
        const SizedBox(height: AppSpacing.xl),
        Row(
          children: [
            MiButton(
              key: const ValueKey<String>('pin-enter'),
              label: ParentalPinCopy.enterPinAction,
              onPressed: onEnterPin,
            ),
            const SizedBox(width: AppSpacing.md),
            MiButton(
              key: const ValueKey<String>('pin-ask-parent'),
              label: ParentalPinCopy.askParentAction,
              emphasis: ControlEmphasis.secondary,
              onPressed: onEnterPin,
            ),
          ],
        ),
      ],
    );
  }
}
