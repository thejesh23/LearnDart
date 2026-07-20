// N-bonacci sequences generalise Fibonacci to sums of the previous
// n terms instead of the previous 2:
//   - 2-bonacci  = Fibonacci     (1, 1, 2, 3, 5, 8, 13, 21, ...)
//   - 3-bonacci  = Tribonacci    (0, 0, 1, 1, 2, 4, 7, 13, 24, ...)
//   - 4-bonacci  = Tetranacci    (...)
//   - k-bonacci
//
// The recurrence is  a(i) = a(i-1) + a(i-2) + ... + a(i-n).
// A naïve implementation summing n previous terms each step is
// O(m·n). The sliding-window trick — recognise that the new sum
// equals the old sum plus the newest term minus the *oldest* term
// that just fell out of the window — brings it down to O(m).
//
// Seed convention (matches OEIS A092921 etc.): (n-1) zeros, then
// a single 1, then apply the recurrence. So a(n-1) = 1 and
// a(n) = 1.
//
// Elegant tie-in: 2-bonacci reduces to Fibonacci exactly.
List<int> nBonacci(int n, int m) {
  if (n < 2) throw ArgumentError('n must be ≥ 2');
  if (m <= 0) return const [];
  final out = List<int>.filled(m, 0);
  if (n - 1 < m) out[n - 1] = 1;
  if (n < m) out[n] = 1;
  int windowSum = out[n - 1] + (n < m ? out[n] : 0);
  for (int i = n + 1; i < m; i++) {
    windowSum = 2 * out[i - 1] - out[i - 1 - n];
    out[i] = windowSum;
  }
  return out;
}

void main() {
  print(nBonacci(2, 10));  // [0,1,1,2,3,5,8,13,21,34]  (Fibonacci)
  print(nBonacci(3, 10));  // [0,0,1,1,2,4,7,13,24,44]  (Tribonacci)
  print(nBonacci(4, 10));  // [0,0,0,1,1,2,4,8,15,29]   (Tetranacci)
  print(nBonacci(6, 10));  // [0,0,0,0,0,1,1,2,4,8]
}
