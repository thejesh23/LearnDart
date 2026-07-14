// Exponential search: double the range until it brackets the target, then
// binary search inside it. Useful when the size is unbounded or unknown.
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
