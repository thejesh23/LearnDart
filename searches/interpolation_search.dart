// Interpolation search: assume values are uniformly distributed and estimate
// the probe position rather than always picking the midpoint. O(log log n)
// on uniform data; O(n) worst case.
int interpolationSearch(List<int> sorted, int target) {
  int lo = 0, hi = sorted.length - 1;
  while (lo <= hi && target >= sorted[lo] && target <= sorted[hi]) {
    if (lo == hi) return sorted[lo] == target ? lo : -1;
    final pos = lo +
        ((target - sorted[lo]) * (hi - lo)) ~/ (sorted[hi] - sorted[lo]);
    if (sorted[pos] == target) return pos;
    if (sorted[pos] < target) {
      lo = pos + 1;
    } else {
      hi = pos - 1;
    }
  }
  return -1;
}

void main() {
  final data = [10, 12, 13, 16, 18, 19, 20, 21, 22, 23, 24, 33, 35, 42, 47];
  print(interpolationSearch(data, 18)); // 4
  print(interpolationSearch(data, 5));  // -1
}
