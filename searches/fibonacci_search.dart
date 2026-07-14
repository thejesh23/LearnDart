// Fibonacci search: like binary search but the split index is derived from
// Fibonacci numbers. Uses only addition/subtraction to advance the range.
int fibonacciSearch(List<int> sorted, int target) {
  final n = sorted.length;
  int fibMm2 = 0;
  int fibMm1 = 1;
  int fibM = fibMm2 + fibMm1;
  while (fibM < n) {
    fibMm2 = fibMm1;
    fibMm1 = fibM;
    fibM = fibMm2 + fibMm1;
  }
  int offset = -1;
  while (fibM > 1) {
    final i = (offset + fibMm2 < n - 1) ? offset + fibMm2 : n - 1;
    if (sorted[i] < target) {
      fibM = fibMm1;
      fibMm1 = fibMm2;
      fibMm2 = fibM - fibMm1;
      offset = i;
    } else if (sorted[i] > target) {
      fibM = fibMm2;
      fibMm1 -= fibMm2;
      fibMm2 = fibM - fibMm1;
    } else {
      return i;
    }
  }
  if (fibMm1 == 1 && offset + 1 < n && sorted[offset + 1] == target) {
    return offset + 1;
  }
  return -1;
}

void main() {
  final data = [10, 22, 35, 40, 45, 50, 80, 82, 85, 90, 100];
  print(fibonacciSearch(data, 85));
  print(fibonacciSearch(data, 15));
}
