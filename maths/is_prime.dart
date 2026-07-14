bool isPrime(int n) {
  if (n < 2) return false;
  if (n < 4) return true;
  if (n % 2 == 0) return false;
  for (int i = 3; i * i <= n; i += 2) {
    if (n % i == 0) return false;
  }
  return true;
}

void main() {
  for (final n in [0, 1, 2, 3, 4, 17, 97, 100, 7919]) {
    print('$n prime? ${isPrime(n)}');
  }
}
