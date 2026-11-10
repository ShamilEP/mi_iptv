import 'tv_search_result.dart';

/// Outcome of tolerant TV search matching (DSN-065).
class TolerantSearchOutcome {
  const TolerantSearchOutcome({
    required this.matches,
    this.suggestions = const <String>[],
    this.didYouMean,
  });

  /// Direct / fuzzy title hits to show as results.
  final List<TvSearchResult> matches;

  /// Completions and near-spellings for the query (chip row).
  final List<String> suggestions;

  /// Best alternate spelling when exact contains-match is empty.
  final String? didYouMean;
}

/// Local tolerant matching for the Search design shell (no search API).
///
/// Supports contains, prefix, and small edit-distance recovery for typos.
abstract final class TolerantSearch {
  static const int maxSuggestions = 5;
  static const int maxEditDistance = 2;

  static TolerantSearchOutcome query(
    String rawQuery,
    List<TvSearchResult> catalog,
  ) {
    final q = rawQuery.trim().toLowerCase();
    if (q.isEmpty) {
      return TolerantSearchOutcome(matches: List<TvSearchResult>.of(catalog));
    }

    final contains = <TvSearchResult>[];
    final fuzzy = <TvSearchResult>[];
    final suggestionScores = <String, int>{};

    for (final item in catalog) {
      final title = item.title.toLowerCase();
      final compactTitle = title.replaceAll(RegExp(r'\s+'), '');
      final subtitle = item.subtitle.toLowerCase();
      if (title.contains(q) ||
          subtitle.contains(q) ||
          compactTitle.contains(q)) {
        contains.add(item);
        _offerSuggestion(suggestionScores, item.title, q, prefer: true);
        continue;
      }

      final distance = _editDistance(q, title);
      final compactDistance = _editDistance(q, compactTitle);
      final wordDistance = _bestWordDistance(q, title);
      final bestDistance = [
        distance,
        compactDistance,
        wordDistance,
      ].reduce((a, b) => a < b ? a : b);
      final prefix = title.startsWith(q) ||
          compactTitle.startsWith(q) ||
          _wordsStartWith(title, q);
      if (prefix || (q.length >= 2 && bestDistance <= maxEditDistance)) {
        fuzzy.add(item);
        _offerSuggestion(suggestionScores, item.title, q, prefer: prefix);
      } else if (q.length >= 2 && bestDistance <= maxEditDistance + 1) {
        _offerSuggestion(suggestionScores, item.title, q, prefer: false);
      }
    }

    final matches = contains.isNotEmpty ? contains : fuzzy;
    final suggestions = _rankedSuggestions(suggestionScores)
        .where((s) => s.toLowerCase() != q)
        .take(maxSuggestions)
        .toList(growable: false);

    // Only surface "Did you mean" when nothing matched as a result row.
    final didYouMean =
        matches.isEmpty && suggestions.isNotEmpty ? suggestions.first : null;

    return TolerantSearchOutcome(
      matches: matches,
      suggestions: suggestions,
      didYouMean: didYouMean,
    );
  }

  static bool _wordsStartWith(String title, String q) {
    for (final part in title.split(RegExp(r'\s+'))) {
      if (part.startsWith(q)) return true;
    }
    return false;
  }

  static int _bestWordDistance(String q, String title) {
    var best = q.length + title.length;
    for (final part in title.split(RegExp(r'\s+'))) {
      final d = _levenshtein(q, part);
      if (d < best) best = d;
    }
    return best;
  }

  static void _offerSuggestion(
    Map<String, int> scores,
    String title,
    String q, {
    required bool prefer,
  }) {
    final distance = _bestWordDistance(q, title.toLowerCase());
    final score = (prefer ? 100 : 0) - distance * 10 + title.length.clamp(0, 20);
    final existing = scores[title];
    if (existing == null || score > existing) {
      scores[title] = score;
    }
  }

  static List<String> _rankedSuggestions(Map<String, int> scores) {
    final entries = scores.entries.toList()
      ..sort((a, b) {
        final byScore = b.value.compareTo(a.value);
        if (byScore != 0) return byScore;
        return a.key.compareTo(b.key);
      });
    return entries.map((e) => e.key).toList(growable: false);
  }

  static int _editDistance(String a, String b) {
    if (a == b) return 0;
    if (a.isEmpty) return b.length;
    if (b.isEmpty) return a.length;
    return _levenshtein(a, b);
  }

  static int _levenshtein(String a, String b) {
    final m = a.length;
    final n = b.length;
    final prev = List<int>.generate(n + 1, (j) => j);
    final curr = List<int>.filled(n + 1, 0);
    for (var i = 1; i <= m; i++) {
      curr[0] = i;
      for (var j = 1; j <= n; j++) {
        final cost = a.codeUnitAt(i - 1) == b.codeUnitAt(j - 1) ? 0 : 1;
        final del = prev[j] + 1;
        final ins = curr[j - 1] + 1;
        final sub = prev[j - 1] + cost;
        curr[j] = del < ins
            ? (del < sub ? del : sub)
            : (ins < sub ? ins : sub);
      }
      for (var j = 0; j <= n; j++) {
        prev[j] = curr[j];
      }
    }
    return prev[n];
  }
}
