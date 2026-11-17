import 'package:flutter/material.dart';

import '../../../../core/platform/companion_platform.dart';
import '../../../../core/platform/companion_platform_shell.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/brand_lockup.dart';
import '../../../../core/widgets/control_chrome.dart';
import '../../../../core/widgets/mi_button.dart';
import '../../../../core/widgets/mi_text_field.dart';
import '../pairing_code_models.dart';

/// Companion pairing-code entry design shell (DSN-071).
class CompanionPairingCodePage extends StatefulWidget {
  const CompanionPairingCodePage({
    super.key,
    this.initialScreen = PairingCodeScreen.entry,
    this.expectedCode = PairingCodeCopy.demoExpectedCode,
    this.platform = CompanionPlatform.android,
    this.onLinked,
    this.onCancel,
  });

  final PairingCodeScreen initialScreen;
  final String expectedCode;
  final CompanionPlatform platform;
  final VoidCallback? onLinked;
  final VoidCallback? onCancel;

  @override
  State<CompanionPairingCodePage> createState() =>
      _CompanionPairingCodePageState();
}

class _CompanionPairingCodePageState extends State<CompanionPairingCodePage> {
  late PairingCodeScreen _screen = widget.initialScreen;
  final TextEditingController _controller = TextEditingController();
  bool _wrong = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String raw) {
    final digits = MiTextField.sanitize(raw).replaceAll(RegExp(r'\D'), '');
    final clipped = digits.length > PairingCodeCopy.codeLength
        ? digits.substring(0, PairingCodeCopy.codeLength)
        : digits;
    if (clipped != _controller.text) {
      _controller.value = TextEditingValue(
        text: clipped,
        selection: TextSelection.collapsed(offset: clipped.length),
      );
    }
    setState(() => _wrong = false);
  }

  void _submit() {
    final value = _controller.text;
    if (value.length != PairingCodeCopy.codeLength) {
      setState(() => _wrong = true);
      return;
    }
    if (value == widget.expectedCode) {
      setState(() {
        _wrong = false;
        _screen = PairingCodeScreen.linked;
      });
      widget.onLinked?.call();
      return;
    }
    setState(() {
      _wrong = true;
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final textTheme = Theme.of(context).textTheme;

    return CompanionPlatformShell(
      platform: widget.platform,
      child: Scaffold(
        backgroundColor: brand.cloud,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.insetPageCompanion),
            child: _screen == PairingCodeScreen.linked
                ? _linked(brand, textTheme)
                : _entry(brand, textTheme),
          ),
        ),
      ),
    );
  }

  Widget _entry(MiBrandColors brand, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const BrandLockup(
          markHeight: AppSpacing.xl,
          tone: BrandMarkTone.companion,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          PairingCodeCopy.companionTitle,
          style: textTheme.headlineMedium?.copyWith(color: brand.ink),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          PairingCodeCopy.companionBody,
          style: textTheme.bodyLarge?.copyWith(color: brand.muted),
        ),
        const SizedBox(height: AppSpacing.lg),
        MiTextField(
          key: const ValueKey<String>('pairing-companion-field'),
          controller: _controller,
          label: PairingCodeCopy.companionFieldLabel,
          keyboardType: TextInputType.number,
          onChanged: _onChanged,
        ),
        if (_wrong) ...[
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Icon(
                Icons.error_outline,
                color: brand.error,
                size: AppSpacing.lg,
                semanticLabel: PairingCodeCopy.companionWrong,
              ),
              const SizedBox(width: AppSpacing.xs),
              Flexible(
                child: Text(
                  PairingCodeCopy.companionWrong,
                  key: const ValueKey<String>('pairing-companion-wrong'),
                  style: textTheme.bodyMedium?.copyWith(color: brand.error),
                ),
              ),
            ],
          ),
        ],
        const Spacer(),
        MiButton(
          key: const ValueKey<String>('pairing-companion-submit'),
          label: PairingCodeCopy.companionSubmit,
          onPressed: _submit,
        ),
        const SizedBox(height: AppSpacing.sm),
        MiButton(
          key: const ValueKey<String>('pairing-companion-cancel'),
          label: PairingCodeCopy.companionCancel,
          emphasis: ControlEmphasis.secondary,
          onPressed: widget.onCancel,
        ),
      ],
    );
  }

  Widget _linked(MiBrandColors brand, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.check_circle_outline,
          key: const ValueKey<String>('pairing-companion-linked-icon'),
          color: brand.success,
          size: AppSpacing.xxl,
          semanticLabel: PairingCodeCopy.companionLinkedTitle,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          PairingCodeCopy.companionLinkedTitle,
          style: textTheme.headlineMedium?.copyWith(color: brand.ink),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          PairingCodeCopy.companionLinkedBody,
          style: textTheme.bodyLarge?.copyWith(color: brand.muted),
        ),
      ],
    );
  }
}
