import 'dart:math';

// Multinomial Naive Bayes text classifier with Laplace smoothing.
class NaiveBayes {
  final Map<String, int> _classCounts = {};
  final Map<String, Map<String, int>> _wordCounts = {};
  final Map<String, int> _classTotals = {};
  final Set<String> _vocab = {};

  void train(List<String> docs, List<String> labels) {
    for (int i = 0; i < docs.length; i++) {
      final label = labels[i];
      _classCounts[label] = (_classCounts[label] ?? 0) + 1;
      _wordCounts[label] ??= {};
      for (final w in _tokens(docs[i])) {
        _vocab.add(w);
        _wordCounts[label]![w] = (_wordCounts[label]![w] ?? 0) + 1;
        _classTotals[label] = (_classTotals[label] ?? 0) + 1;
      }
    }
  }

  String predict(String doc) {
    final tokens = _tokens(doc);
    final totalDocs = _classCounts.values.fold<int>(0, (a, b) => a + b);
    String? best;
    double bestScore = double.negativeInfinity;
    for (final label in _classCounts.keys) {
      double score = log(_classCounts[label]! / totalDocs);
      final total = _classTotals[label]!;
      for (final w in tokens) {
        final wc = _wordCounts[label]![w] ?? 0;
        score += log((wc + 1) / (total + _vocab.length));
      }
      if (score > bestScore) { bestScore = score; best = label; }
    }
    return best!;
  }

  List<String> _tokens(String doc) =>
      doc.toLowerCase().split(RegExp(r'\W+')).where((w) => w.isNotEmpty).toList();
}

void main() {
  final nb = NaiveBayes()
    ..train([
      'buy cheap meds now', 'meet me at noon', 'cheap loan approved',
      'lunch tomorrow?', 'win a prize now',
    ], [
      'spam', 'ham', 'spam', 'ham', 'spam',
    ]);
  print(nb.predict('cheap prize'));        // spam
  print(nb.predict('lunch tomorrow'));     // ham
}
