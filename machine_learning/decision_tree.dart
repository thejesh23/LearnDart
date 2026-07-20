// ID3-style decision tree for categorical features. At each node, pick
// the feature whose split most reduces entropy — the "information gain".
// Recurse until every leaf is pure (all one label) or no features are
// left, in which case the leaf votes majority.
//
// Entropy H = -sum(p_i · log2 p_i) measures how mixed a set of labels
// is. Gain(feature) = H(parent) - weighted average of H(children). The
// greedy top-down choice is not globally optimal (finding the smallest
// consistent tree is NP-hard) but works well in practice.
//
// Downsides: overfits easily, unstable under small data changes,
// prefers features with many distinct values. Real systems use pruning
// (C4.5), Gini impurity instead of entropy (CART), or ensembles like
// random forests and gradient-boosted trees. Complexity: O(n · d · depth).
import 'dart:math';

double _entropy(List<String> labels) {
  if (labels.isEmpty) return 0;
  final counts = <String, int>{};
  for (final l in labels) counts[l] = (counts[l] ?? 0) + 1;
  double h = 0;
  for (final c in counts.values) {
    final p = c / labels.length;
    h -= p * (log(p) / ln2);
  }
  return h;
}

class _Node {
  final String? label;
  final String? feature;
  final Map<String, _Node> children;
  _Node.leaf(this.label) : feature = null, children = const {};
  _Node.split(this.feature, this.children) : label = null;
}

class DecisionTree {
  late final _Node _root;

  DecisionTree.fit(List<Map<String, String>> data,
      List<String> labels, List<String> features) {
    _root = _build(data, labels, features);
  }

  _Node _build(List<Map<String, String>> data, List<String> labels,
      List<String> features) {
    if (labels.toSet().length == 1) return _Node.leaf(labels.first);
    if (features.isEmpty) return _Node.leaf(_majority(labels));

    final base = _entropy(labels);
    String? bestFeature;
    double bestGain = -1;
    for (final f in features) {
      final values = <String, List<int>>{};
      for (int i = 0; i < data.length; i++) {
        values.putIfAbsent(data[i][f]!, () => []).add(i);
      }
      double weighted = 0;
      for (final idxs in values.values) {
        final subLabels = [for (final i in idxs) labels[i]];
        weighted += (idxs.length / labels.length) * _entropy(subLabels);
      }
      final gain = base - weighted;
      if (gain > bestGain) { bestGain = gain; bestFeature = f; }
    }

    final children = <String, _Node>{};
    final remainingFeatures = features.where((f) => f != bestFeature).toList();
    final groups = <String, List<int>>{};
    for (int i = 0; i < data.length; i++) {
      groups.putIfAbsent(data[i][bestFeature]!, () => []).add(i);
    }
    for (final e in groups.entries) {
      final subData = [for (final i in e.value) data[i]];
      final subLabels = [for (final i in e.value) labels[i]];
      children[e.key] = _build(subData, subLabels, remainingFeatures);
    }
    return _Node.split(bestFeature!, children);
  }

  String _majority(List<String> labels) {
    final counts = <String, int>{};
    for (final l in labels) counts[l] = (counts[l] ?? 0) + 1;
    var best = counts.entries.first;
    for (final e in counts.entries) {
      if (e.value > best.value) best = e;
    }
    return best.key;
  }

  String predict(Map<String, String> sample) {
    var n = _root;
    while (n.label == null) {
      final v = sample[n.feature];
      final next = n.children[v];
      if (next == null) return _majority(n.children.values.map((c) => c.label ?? '').toList());
      n = next;
    }
    return n.label!;
  }
}

void main() {
  final data = <Map<String, String>>[
    {'weather': 'sunny',    'temp': 'hot',  'wind': 'weak'},
    {'weather': 'sunny',    'temp': 'hot',  'wind': 'strong'},
    {'weather': 'overcast', 'temp': 'hot',  'wind': 'weak'},
    {'weather': 'rain',     'temp': 'mild', 'wind': 'weak'},
    {'weather': 'rain',     'temp': 'cool', 'wind': 'weak'},
    {'weather': 'rain',     'temp': 'cool', 'wind': 'strong'},
    {'weather': 'overcast', 'temp': 'cool', 'wind': 'strong'},
  ];
  final labels = ['no', 'no', 'yes', 'yes', 'yes', 'no', 'yes'];
  final tree = DecisionTree.fit(data, labels, ['weather', 'temp', 'wind']);
  print(tree.predict({'weather': 'sunny', 'temp': 'mild', 'wind': 'weak'}));
  print(tree.predict({'weather': 'rain',  'temp': 'cool', 'wind': 'strong'}));
}
