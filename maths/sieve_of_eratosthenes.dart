List<int> sieveOfEratosthenes(int limit) {
  if (limit < 2) return const [];
  final isComposite = List<bool>.filled(limit + 1, false);
  final primes = <int>[];
  for (int i = 2; i <= limit; i++) {
    if (isComposite[i]) continue;
    primes.add(i);
    for (int j = i * i; j <= limit; j += i) {
      isComposite[j] = true;
    }
  }
  return primes;
}

void main() {
  print(sieveOfEratosthenes(30));
  print('primes up to 100: ${sieveOfEratosthenes(100).length}');
}
