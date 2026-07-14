// Recursive binary search. Precondition: `sorted` is sorted ascending.
int binarySearchRecursive(List<int> sorted, int target,
    [int? lo, int? hi]) {
  lo ??= 0;
  hi ??= sorted.length - 1;
  if (lo > hi) return -1;
  final mid = lo + (hi - lo) ~/ 2;
  if (sorted[mid] == target) return mid;
  if (sorted[mid] < target) {
    return binarySearchRecursive(sorted, target, mid + 1, hi);
  }
  return binarySearchRecursive(sorted, target, lo, mid - 1);
}

void main() {
  final data = [1, 3, 5, 7, 9, 11, 13];
  print(binarySearchRecursive(data, 7));
  print(binarySearchRecursive(data, 4));
}
