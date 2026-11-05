import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/brand_lockup.dart';
import '../../../../core/widgets/content_card.dart';
import '../../../../core/widgets/content_row.dart';
import '../../../../core/widgets/content_row_list.dart';

/// Temporary TV Home shell until feature screens land.
class TvHomePlaceholderPage extends StatelessWidget {
  const TvHomePlaceholderPage({super.key});

  static const _continueWatching = <({String title, String subtitle, double progress})>[
    (title: 'Harness ready', subtitle: 'Sprint 0', progress: 0.35),
    (title: 'Focus memory', subtitle: 'DSN-012', progress: 0.6),
    (title: 'Signal progress', subtitle: 'Continue', progress: 0.15),
  ];

  static const _posters = <String>[
    'Poster A',
    'Poster B',
    'Poster C',
    'Poster D',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: AppOverscan.padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BrandLockup(markHeight: 56),
            const SizedBox(height: AppSpacing.stack),
            Expanded(
              child: ContentRowList(
                rowCount: 2,
                rowBuilder: (context, rowIndex) {
                  if (rowIndex == 0) {
                    return ContentRow(
                      title: 'Continue watching',
                      storageId: 'home-continue-watching',
                      kind: ContentCardKind.continueWatching,
                      itemCount: _continueWatching.length,
                      placeholderCount: 1,
                      itemBuilder: (context, index, focusNode) {
                        final item = _continueWatching[index];
                        return ContentCard(
                          kind: ContentCardKind.continueWatching,
                          title: item.title,
                          subtitle: item.subtitle,
                          progress: item.progress,
                          focusNode: focusNode,
                          onPressed: () {},
                        );
                      },
                    );
                  }
                  return ContentRow(
                    title: 'Featured',
                    storageId: 'home-featured',
                    kind: ContentCardKind.poster,
                    itemCount: _posters.length,
                    itemBuilder: (context, index, focusNode) {
                      return ContentCard(
                        kind: ContentCardKind.poster,
                        title: _posters[index],
                        focusNode: focusNode,
                        onPressed: () {},
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
