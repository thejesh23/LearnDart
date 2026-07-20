import 'dart:math';

// k-nearest-neighbors classifier: predict the label of a query point by
// looking at the k labeled training points closest to it and taking the
// majority vote.
//
// KNN is a "lazy learner" — there's no training phase, just remembering
// the data. All the work happens at prediction time. Simple, interpretable,
// and surprisingly effective on small datasets. Downsides: predictions
// scale linearly with training set size (unless you index with a KD-tree
// — see data_structures/kd_tree.dart), and the algorithm suffers badly
// when features are on wildly different scales (normalize first) or when
// the input is high-dimensional (the "curse of dimensionality").
//
// Complexity: O(n · d) per prediction with a naive scan (as here), or
// O(log n) average with a KD-tree in low dimensions.
double _dist(List<double> a, List<double> b) {
  double sum = 0;
  for (int i = 0; i < a.length; i++) {
    final d = a[i] - b[i];
    sum += d * d;
  }
  return sqrt(sum);
}

String knnClassify(
    List<List<double>> trainX, List<String> trainY,
    List<double> query, int k) {
  final ranked = List<int>.generate(trainX.length, (i) => i)
    ..sort((a, b) => _dist(trainX[a], query).compareTo(_dist(trainX[b], query)));
  final counts = <String, int>{};
  for (int i = 0; i < k && i < ranked.length; i++) {
    final label = trainY[ranked[i]];
    counts[label] = (counts[label] ?? 0) + 1;
  }
  var winner = counts.entries.first;
  for (final e in counts.entries) {
    if (e.value > winner.value) winner = e;
  }
  return winner.key;
}

void main() {
  final trainX = <List<double>>[
    [1, 1], [1.5, 1.8], [5, 8], [8, 8], [1, 0.6], [9, 11],
  ];
  final trainY = ['A', 'A', 'B', 'B', 'A', 'B'];
  print(knnClassify(trainX, trainY, [3, 4], 3));  // A or B depending on distances
  print(knnClassify(trainX, trainY, [7, 9], 3));  // B
}
