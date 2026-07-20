import 'dart:math';

// Pollard's rho: find a non-trivial factor of a composite integer.
// Expected O(n^(1/4)) time — dramatically better than the O(√n) of
// trial division and the main algorithm used to factor "medium-sized"
// composites (up to ~60 bits) before switching to quadratic sieve or
// number field sieve for larger inputs.
//
// The trick: iterate a pseudo-random function x -> (x^2 + c) mod n
// with two "hares", one running twice as fast as the other. By the
// birthday paradox, in ~√p iterations (where p is the smallest prime
// factor) the two hares' values differ by a multiple of p, so their
// gcd with n reveals p.
//
// If the hares cycle without finding a factor (d == n), re-randomize
// c and try again. Complexity: expected O(n^(1/4)); worst case
// unbounded (but astronomically unlikely).
BigInt _gcd(BigInt a, BigInt b) {
  while (b != BigInt.zero) { final t = b; b = a % b; a = t; }
  return a;
}

BigInt? pollardRho(BigInt n) {
  if (n.isEven) return BigInt.two;
  final rng = Random();
  while (true) {
    var x = BigInt.from(rng.nextInt(0x3fffffff)) % (n - BigInt.two) + BigInt.two;
    var y = x;
    final c = BigInt.from(rng.nextInt(0x3fffffff)) % (n - BigInt.one) + BigInt.one;
    var d = BigInt.one;
    while (d == BigInt.one) {
      x = (x * x + c) % n;
      y = (y * y + c) % n;
      y = (y * y + c) % n;
      d = _gcd((x - y).abs(), n);
    }
    if (d != n) return d;
  }
}

void main() {
  for (final n in [BigInt.from(91), BigInt.from(8051), BigInt.parse('10403')]) {
    final f = pollardRho(n);
    print('$n -> factor $f (co-factor ${n ~/ f!})');
  }
}
