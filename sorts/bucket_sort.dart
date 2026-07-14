// Bucket sort for values in [0.0, 1.0). For general ranges, rescale first.
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
