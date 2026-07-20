// Bucket sort: distribute input into n buckets by value, sort each
// bucket internally (or recursively bucket-sort it), then concatenate.
//
// Runs in expected O(n) time when the input is *uniformly distributed*
// — each bucket gets O(1) elements, the per-bucket sort is O(1) work,
// and the total dominates as O(n). On adversarial input (all values
// land in one bucket) it degrades to whatever the inner sort's worst
// case is — O(n^2) for insertion sort, O(n log n) for merge/quick.
//
// This variant handles values in [0.0, 1.0). For general ranges,
// rescale to [0.0, 1.0) first. Complexity: expected O(n) for uniform
// input, worst O(n^2), O(n + k) space.
List<double> bucketSort(List<double> input) {
  final n = input.length;
  if (n == 0) return [];
  final buckets = List.generate(n, (_) => <double>[]);
  for (final v in input) {
    final idx = (v * n).floor().clamp(0, n - 1);
    buckets[idx].add(v);
  }
  final out = <double>[];
  for (final b in buckets) {
    b.sort();
    out.addAll(b);
  }
  return out;
}

void main() {
  print(bucketSort([0.42, 0.32, 0.23, 0.52, 0.25, 0.47, 0.51]));
}
