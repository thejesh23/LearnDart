// Exponential (a.k.a. galloping / doubling) search on a sorted list.
// First phase doubles the index (1, 2, 4, 8, ...) until it overshoots
// the target — this bracket-finding takes O(log p) probes where p is
// the target's true position. Second phase binary-searches within the
// bracket.
//
// Total: O(log p), which beats plain binary search's O(log n) when p
// is much smaller than n — the target sits near the start. Especially
// useful when n is huge, unknown, or unbounded (a streaming source, an
// infinite list generator).
//
// Also called "one-sided binary search". Used in classical library
// merging routines for exactly this "find the split point cheaply
// when it's near the start" reason.
int _binaryRange(List<int> a, int target, int lo, int hi) {
  while (lo <= hi) {
    final mid = lo + (hi - lo) ~/ 2;
    if (a[mid] == target) return mid;
    if (a[mid] < target) {
      lo = mid + 1;
    } else {
      hi = mid - 1;
    }
  }
  return -1;
}

int exponentialSearch(List<int> sorted, int target) {
  if (sorted.isEmpty) return -1;
  if (sorted[0] == target) return 0;
  int i = 1;
  while (i < sorted.length && sorted[i] <= target) {
    i *= 2;
  }
  final hi = i < sorted.length ? i : sorted.length - 1;
  return _binaryRange(sorted, target, i ~/ 2, hi);
}

void main() {
  final data = [2, 3, 4, 10, 40, 45, 60, 75, 89, 99];
  print(exponentialSearch(data, 45));
  print(exponentialSearch(data, 5));
}
