// Iterative binary search. Precondition: `sorted` is sorted ascending.
int binarySearch(List<int> sorted, int target) {
  int lo = 0;
  int hi = sorted.length - 1;
  while (lo <= hi) {
    final mid = lo + (hi - lo) ~/ 2;
    if (sorted[mid] == target) return mid;
    if (sorted[mid] < target) {
      lo = mid + 1;
    } else {
      hi = mid - 1;
    }
  }
  return -1;
}

void main() {
  final data = [1, 3, 5, 7, 9, 11, 13];
  print(binarySearch(data, 7));  // 3
  print(binarySearch(data, 4));  // -1
}
