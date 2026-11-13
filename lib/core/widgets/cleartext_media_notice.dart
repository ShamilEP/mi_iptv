import 'package:flutter/material.dart';

import '../network/transport_security_policy.dart';
import '../theme/theme.dart';

/// Non-blocking banner when a media URL uses cleartext HTTP (SEC-023).
///
/// Prefer showing this whenever [TransportSecurityPolicy.requiresCleartextMediaWarning]
/// is true for the active stream. Does not log the URI.
class CleartextMediaNotice extends StatelessWidget {
  const CleartextMediaNotice({
    super.key,
    this.message = TransportSecurityPolicy.cleartextMediaWarning,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    return Semantics(
      liveRegion: true,
      label: message,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: brand.panel,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(color: brand.warning),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              Icon(
                Icons.lock_open_outlined,
                color: brand.warning,
                size: AppSpacing.lg,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: brand.cloud,
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
