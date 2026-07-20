import 'dart:math';

// k-nearest-neighbors classifier. No training phase — predictions look at
// the k closest labeled points and pick the majority label.
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
