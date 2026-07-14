// Count integers in [1, n] coprime with n using its prime factorization.
int eulerTotient(int n) {
  int result = n;
  int x = n;
  for (int p = 2; p * p <= x; p++) {
    if (x % p == 0) {
      while (x % p == 0) x ~/= p;
      result -= result ~/ p;
    }
  }
  if (x > 1) result -= result ~/ x;
  return result;
}

void main() {
  for (final n in [1, 2, 3, 6, 9, 10, 36, 100]) {
    print('phi($n) = ${eulerTotient(n)}');
  }
}
