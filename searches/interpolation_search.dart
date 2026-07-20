// Interpolation search: on sorted data, estimate where the target likely
// sits by linear interpolation between the endpoints — same idea as
// looking up "Smith" in a phone book by jumping most of the way to the
// end rather than always to the middle.
//
// The probe formula pos = lo + (target - a[lo]) * (hi - lo) / (a[hi] - a[lo])
// assumes values are *uniformly distributed* between the endpoints.
// When that holds it's O(log log n) — much faster than binary search.
// When it doesn't (skewed or clustered values), it degrades all the way
// to O(n).
//
// Real-world uses are rare because sorted data + uniform distribution
// is a narrow band. Complexity: O(log log n) average, O(n) worst case.
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
