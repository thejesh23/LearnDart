// NTT — Number Theoretic Transform.
// FFT over a prime field instead of complex numbers, giving exact integer
// arithmetic.  Essential in competitive programming and cryptography
// (e.g., lattice-based post-quantum schemes, polynomial multiplication
// in CRYSTALS-Kyber/Dilithium, large integer multiplication).
//
// Why NTT?  FFT accumulates floating-point rounding errors.  For
// polynomial coefficients that must be exact integers (e.g., counting
// paths in a graph, multiplying big integers), even a 1-ULP error
// produces a wrong coefficient after rounding.
//
// NTT-friendly prime: we need a prime p such that:
//   1. p ≡ 1 (mod 2^k) for large enough k (to support transforms of
//      length up to 2^k).
//   2. A primitive 2^k-th root of unity exists in Z/pZ.
//
// p = 998244353 = 119 × 2^23 + 1 is the standard competitive-programming
// choice: primitive root g=3, supports transforms of length up to 2^23.
//
// Butterfly operation: same as Cooley-Tukey FFT but with modular
// arithmetic.  The "twiddle factor" w = g^((p-1)/n) mod p replaces
// e^{-2πi/n}.
//
// Inverse NTT: same as forward but with w replaced by w^{-1} and result
// scaled by n^{-1} mod p.
//
// Relation to numeric/fft.dart: NTT is algebraically identical to FFT;
// replace C field with Z/pZ, complex roots of unity with primitive roots.
//
// Run:  dart run numeric/ntt.dart

const int _P = 998244353;   // NTT-friendly prime: 119 × 2^23 + 1
const int _G = 3;           // primitive root of Z/pZ

// --- modular arithmetic helpers ----------------------------------------

int _mod(int a) => ((a % _P) + _P) % _P;
int _mulmod(int a, int b) => _mod(a * b);   // ok for 64-bit Dart ints up to ~2^61

int _powmod(int base, int exp, int mod) {
  int result = 1;
  base %= mod;
  while (exp > 0) {
    if (exp & 1 == 1) result = result * base % mod;
    base = base * base % mod;
    exp >>= 1;
  }
  return result;
}

int _invmod(int a) => _powmod(a, _P - 2, _P);

// --- NTT (iterative Cooley-Tukey, in-place) ---------------------------

/// In-place NTT.  [a] must have power-of-2 length.
/// [inverse] = true for INTT.
void ntt(List<int> a, bool inverse) {
  final n = a.length;
  assert(n & (n - 1) == 0);

  // Bit-reversal permutation.
  for (int i = 1, j = 0; i < n; i++) {
    int bit = n >> 1;
    for (; j & bit != 0; bit >>= 1) j ^= bit;
    j ^= bit;
    if (i < j) {
      final tmp = a[i]; a[i] = a[j]; a[j] = tmp;
    }
  }

  // Butterfly stages.
  for (int len = 2; len <= n; len <<= 1) {
    // Primitive len-th root of unity in Z/pZ.
    int w = inverse
        ? _invmod(_powmod(_G, (_P - 1) ~/ len, _P))
        : _powmod(_G, (_P - 1) ~/ len, _P);

    for (int i = 0; i < n; i += len) {
      int wn = 1;
      for (int j = 0; j < len ~/ 2; j++) {
        final u = a[i + j];
        final v = a[i + j + len ~/ 2] * wn % _P;
        a[i + j]               = _mod(u + v);
        a[i + j + len ~/ 2]    = _mod(u - v);
        wn = wn * w % _P;
      }
    }
  }

  if (inverse) {
    final nInv = _invmod(n);
    for (int i = 0; i < n; i++) a[i] = a[i] * nInv % _P;
  }
}

// --- polynomial multiplication mod p ----------------------------------

List<int> polyMulMod(List<int> a, List<int> b, int mod) {
  int n = 1;
  while (n < a.length + b.length - 1) n <<= 1;

  final fa = [...a.map((v) => _mod(v)), ...List.filled(n - a.length, 0)];
  final fb = [...b.map((v) => _mod(v)), ...List.filled(n - b.length, 0)];

  ntt(fa, false);
  ntt(fb, false);
  final fc = List.generate(n, (i) => fa[i] * fb[i] % _P);
  ntt(fc, true);

  return fc.sublist(0, a.length + b.length - 1)
      .map((v) => v % mod)
      .toList();
}

// --- naive multiplication for verification ----------------------------

List<int> polyMulNaive(List<int> a, List<int> b, int mod) {
  final res = List<int>.filled(a.length + b.length - 1, 0);
  for (int i = 0; i < a.length; i++) {
    for (int j = 0; j < b.length; j++) {
      res[i + j] = (res[i + j] + a[i] * b[j]) % mod;
    }
  }
  return res;
}

// --- demo --------------------------------------------------------------

void main() {
  print('=== NTT — Number Theoretic Transform (mod $_P) ===\n');

  // Sanity: forward + inverse NTT round-trips to identity.
  final x = [1, 2, 3, 4, 0, 0, 0, 0];
  final orig = List<int>.from(x);
  ntt(x, false);
  print('NTT of [1,2,3,4,0,0,0,0]:');
  print('  ${x.join(", ")}');
  ntt(x, true);
  print('INTT (round-trip): ${x.join(", ")}');
  print('Matches original : ${x.toString() == orig.toString()}\n');

  // Same polynomials as fft.dart: [1,2,3] × [4,5,6].
  final a = [1, 2, 3];
  final b = [4, 5, 6];
  final nttResult   = polyMulMod(a, b, _P);
  final naiveResult = polyMulNaive(a, b, _P);
  print('Polynomial multiplication (same as fft.dart):');
  print('  A = $a');
  print('  B = $b');
  print('  NTT result   : $nttResult');
  print('  Naive result : $naiveResult');
  print('  Match        : ${nttResult.toString() == naiveResult.toString()}\n');

  // Large exact multiplication — FFT would accumulate float errors here.
  final size = 512;
  final bigA = List<int>.generate(size, (i) => (i * 7 + 3) % 100);
  final bigB = List<int>.generate(size, (i) => (i * 13 + 5) % 100);

  final sw1 = Stopwatch()..start();
  final r1 = polyMulMod(bigA, bigB, _P); sw1.stop();

  final sw2 = Stopwatch()..start();
  final r2 = polyMulNaive(bigA, bigB, _P); sw2.stop();

  print('Large poly (n=$size):');
  print('  NTT:   ${sw1.elapsedMicroseconds} µs');
  print('  Naive: ${sw2.elapsedMicroseconds} µs');
  print('  Results match: ${r1.toString() == r2.toString()}\n');

  // Explain how to choose NTT-friendly primes.
  print('How to choose NTT-friendly primes:');
  print('  Need p ≡ 1 (mod 2^k) so that nth roots of unity exist for n ≤ 2^k.');
  print('  $_P = 119 × 2^23 + 1  → supports transforms of length ≤ 2^23 = ${1<<23}');
  print('  Other common choices: 469762049 = 7 × 2^26 + 1,  786433 = 3 × 2^18 + 1');
  print('  Primitive root g=3 works for all three; verify g^((p-1)/2) ≡ -1 mod p.');
  print('  g^((p-1)/2) mod p = ${_powmod(3, (_P-1)~/ 2, _P)} (should be ${_P - 1})');
}
