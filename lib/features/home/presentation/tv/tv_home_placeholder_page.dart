import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/focusable_surface.dart';

/// Temporary TV Home shell until feature screens land.
class TvHomePlaceholderPage extends StatelessWidget {
  const TvHomePlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final brand = context.brandColors;
    return Scaffold(
      body: Padding(
        padding: AppOverscan.padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mi IPTV',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: AppSpacing.stackTight),
            Text(
              'Continue watching',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.stack),
            FocusableSurface(
              onPressed: () {},
              child: SizedBox(
                width: 280,
                height: 160,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.insetCard),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Harness ready',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: brand.cloud,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
