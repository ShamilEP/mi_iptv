import 'package:flutter/material.dart';

import '../../../../core/accessibility/tv_accessibility.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/brand_lockup.dart';
import '../../../../core/widgets/control_chrome.dart';
import '../../../../core/widgets/mi_button.dart';
import '../pairing_code_models.dart';

/// TV pairing-code display design shell (DSN-071).
class TvPairingCodePage extends StatefulWidget {
  const TvPairingCodePage({
    super.key,
    this.initialScreen = PairingCodeScreen.showCode,
    this.initialCode = PairingCodeCopy.demoExpectedCode,
    this.onRefreshCode,
  });

  final PairingCodeScreen initialScreen;
  final String initialCode;
  final ValueChanged<String>? onRefreshCode;

  @override
  State<TvPairingCodePage> createState() => _TvPairingCodePageState();
}

class _TvPairingCodePageState extends State<TvPairingCodePage> {
  late PairingCodeScreen _screen = widget.initialScreen;
  late String _code = widget.initialCode;
  int _refreshIndex = 0;

  static const List<String> _demoRefreshCodes = <String>[
    '482913',
    '719304',
    '605281',
  ];

  void _refresh() {
    setState(() {
      _refreshIndex = (_refreshIndex + 1) % _demoRefreshCodes.length;
      _code = _demoRefreshCodes[_refreshIndex];
      _screen = PairingCodeScreen.showCode;
    });
    widget.onRefreshCode?.call(_code);
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
    if (_screen == PairingCodeScreen.linked) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_outline,
            key: const ValueKey<String>('pairing-tv-linked-icon'),
            color: brand.success,
            size: AppSpacing.xxl,
            semanticLabel: PairingCodeCopy.tvLinkedTitle,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            PairingCodeCopy.tvLinkedTitle,
            style: textTheme.headlineMedium?.copyWith(color: brand.cloud),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            PairingCodeCopy.tvLinkedBody,
            style: textTheme.bodyLarge?.copyWith(color: brand.mist),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          PairingCodeCopy.tvTitle,
          style: textTheme.headlineMedium?.copyWith(color: brand.cloud),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          PairingCodeCopy.tvBody,
          style: textTheme.bodyLarge?.copyWith(color: brand.mist),
        ),
        const Spacer(),
        Center(
          child: Text(
            PairingCodeCopy.formatDisplay(_code),
            key: const ValueKey<String>('pairing-tv-code'),
            style: textTheme.displayLarge?.copyWith(
              color: brand.cloud,
              letterSpacing: AppSpacing.xs,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: AppSpacing.lg,
                height: AppSpacing.lg,
                child: CircularProgressIndicator(
                  key: const ValueKey<String>('pairing-tv-waiting'),
                  strokeWidth: 2,
                  color: brand.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                PairingCodeCopy.tvWaiting,
                style: textTheme.bodyLarge?.copyWith(color: brand.mist),
              ),
            ],
          ),
        ),
        const Spacer(),
        MiButton(
          key: const ValueKey<String>('pairing-tv-refresh'),
          label: PairingCodeCopy.tvRefresh,
          emphasis: ControlEmphasis.secondary,
          onPressed: _refresh,
        ),
      ],
    );
  }
}
