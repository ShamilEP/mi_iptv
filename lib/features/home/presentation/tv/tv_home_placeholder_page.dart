import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/brand_lockup.dart';
import '../../../../core/widgets/content_card.dart';

/// Temporary TV Home shell until feature screens land.
class TvHomePlaceholderPage extends StatelessWidget {
  const TvHomePlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: AppOverscan.padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BrandLockup(markHeight: 56),
            const SizedBox(height: AppSpacing.stackTight),
            Text(
              'Continue watching',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.stack),
            ContentCard(
              kind: ContentCardKind.continueWatching,
              title: 'Harness ready',
              subtitle: 'Sprint 0',
              progress: 0.35,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
