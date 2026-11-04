import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/focusable_surface.dart';

/// Temporary TV Home shell until feature screens land.
class TvHomePlaceholderPage extends StatelessWidget {
  const TvHomePlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mi IPTV',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Continue watching',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            FocusableSurface(
              onPressed: () {},
              child: const SizedBox(
                width: 280,
                height: 160,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Harness ready',
                      style: TextStyle(
                        color: AppColors.cloud,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
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
