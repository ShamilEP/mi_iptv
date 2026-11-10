import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';
import 'parental_pin_models.dart';

/// Four obscured PIN slots (DSN-062). Filled slots use a glyph, not the digit.
class ParentalPinDigitsRow extends StatelessWidget {
  const ParentalPinDigitsRow({
    super.key,
    required this.digits,
    this.error = false,
  });

  final ParentalPinDigits digits;
  final bool error;

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    final border = error ? brand.error : brand.border;
    final fill = error ? brand.error.withValues(alpha: 0.12) : brand.surface;

    return Semantics(
      label: ParentalPinCopy.pinLabel,
      value: '${digits.length} of ${ParentalPinCopy.pinLength} digits',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < ParentalPinCopy.pinLength; i++) ...[
            if (i > 0) const SizedBox(width: AppSpacing.sm),
            Container(
              key: ValueKey<String>('pin-slot-$i'),
              width: AppSpacing.xxl,
              height: AppSpacing.xxl,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: fill,
                borderRadius: BorderRadius.circular(AppRadius.sm),
                border: Border.all(color: border, width: 2),
              ),
              child: Text(
                i < digits.length ? '•' : '',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: error ? brand.error : brand.cloud,
                    ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
