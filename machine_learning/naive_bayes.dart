import 'dart:math';

// Multinomial Naive Bayes text classifier. Apply Bayes' theorem
// assuming (naïvely, hence the name) that each word appears
// independently of the others given the class label. In practice this
// assumption is wildly false and yet the classifier works startlingly
// well for spam filtering and document topic tagging.
//
// The score for a document under class c is:
//   log P(c) + sum_w [count_w in doc] · log P(w | c)
// Working in log-space avoids underflow when multiplying many small
// probabilities. Laplace (add-one) smoothing prevents zero probabilities
// from unseen words on the test side — otherwise one novel word would
// veto the entire class.
//
// Complexity: O(sum_d |d|) to train and O(|d| · |C|) per prediction.
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
