import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/tv_osk_key.dart';
import '../parental_pin_models.dart';

/// Numeric PIN pad for TV D-pad entry (DSN-062).
class TvPinPad extends StatelessWidget {
  const TvPinPad({
    super.key,
    required this.onDigit,
    required this.onDelete,
    required this.onClear,
  });

  final ValueChanged<String> onDigit;
  final VoidCallback onDelete;
  final VoidCallback onClear;

  static const List<String> _digits = <String>[
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var row = 0; row < 3; row++) ...[
          if (row > 0) const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var col = 0; col < 3; col++) ...[
                if (col > 0) const SizedBox(width: AppSpacing.sm),
                TvOskKey(
                  key: ValueKey<String>('pin-key-${_digits[row * 3 + col]}'),
                  label: _digits[row * 3 + col],
                  autofocus: row == 0 && col == 0,
                  onPressed: () => onDigit(_digits[row * 3 + col]),
                ),
              ],
            ],
          ),
        ],
        const SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TvOskKey(
              key: const ValueKey<String>('pin-key-clear'),
              label: 'C',
              semanticLabel: ParentalPinCopy.clearLabel,
              onPressed: onClear,
            ),
            const SizedBox(width: AppSpacing.sm),
            TvOskKey(
              key: const ValueKey<String>('pin-key-0'),
              label: '0',
              onPressed: () => onDigit('0'),
            ),
            const SizedBox(width: AppSpacing.sm),
            TvOskKey(
              key: const ValueKey<String>('pin-key-delete'),
              label: '⌫',
              semanticLabel: ParentalPinCopy.deleteLabel,
              onPressed: onDelete,
            ),
          ],
        ),
      ],
    );
  }
}
