int fibonacci(int n) {
  if (n < 0) throw ArgumentError('n must be non-negative');
  if (n < 2) return n;
  int a = 0, b = 1;
  for (int i = 2; i <= n; i++) {
    final c = a + b;
    a = b;
    b = c;
  }
  return b;
}

void main() {
  for (int i = 0; i < 15; i++) {
    print('fib($i) = ${fibonacci(i)}');
  }
}
