// FFT — Cooley-Tukey Fast Fourier Transform.
// Discovered (independently) by Cooley & Tukey (1965); the same algorithm
// was known to Gauss in 1805.  One of the most important algorithms ever.
//
// Discrete Fourier Transform (DFT):
//   X[k] = Σ_{n=0}^{N-1}  x[n] · e^{-2πi·kn/N}    k = 0..N-1
// Naïve evaluation: O(N²) multiplications.
//
// Cooley-Tukey insight: split x into even- and odd-indexed subsequences.
//   DFT(x) = [DFT(even) + w^k · DFT(odd),
//              DFT(even) - w^k · DFT(odd)]  for k = 0..N/2-1
// where w_N = e^{-2πi/N}.  This halves the work recursively → O(N log N).
//
// Applications:
//   • Polynomial multiplication in O(n log n): evaluate at N points via
//     FFT, multiply point-wise, interpolate back via inverse FFT (IFFT).
//   • Signal processing: convolution, filtering.
//   • Numerical analysis: fast matrix-vector products.
//
// This file uses Dart 3.x records `(double re, double im)` for complex
// numbers — a clean alternative to a class with no allocation overhead.
//
// Relation to numeric/ntt.dart: NTT is FFT over a prime field; it gives
// exact integer arithmetic (no floating-point error) and is preferred
// for competitive-programming polynomial multiplication.
//
// Run:  dart run numeric/fft.dart
import 'dart:math';

// --- complex number as a record ----------------------------------------

typedef C = (double re, double im);

C cadd(C a, C b) => (a.$1 + b.$1, a.$2 + b.$2);
C csub(C a, C b) => (a.$1 - b.$1, a.$2 - b.$2);
C cmul(C a, C b) =>
    (a.$1 * b.$1 - a.$2 * b.$2, a.$1 * b.$2 + a.$2 * b.$1);
C cconj(C a) => (a.$1, -a.$2);
C cscale(C a, double s) => (a.$1 * s, a.$2 * s);

String cfmt(C c) {
  final im = c.$2 >= 0 ? '+${c.$2.toStringAsFixed(4)}i'
                       : '${c.$2.toStringAsFixed(4)}i';
  return '${c.$1.toStringAsFixed(4)}$im';
}

// --- FFT (recursive Cooley-Tukey, power-of-2 length) ------------------

List<C> fft(List<C> x, {bool inverse = false}) {
  final n = x.length;
  if (n == 1) return [x[0]];

  assert(n & (n - 1) == 0, 'FFT length must be a power of 2');

  final even = fft([for (int i = 0; i < n; i += 2) x[i]], inverse: inverse);
  final odd  = fft([for (int i = 1; i < n; i += 2) x[i]], inverse: inverse);

  final sign = inverse ? 1.0 : -1.0;
  final result = List<C>.filled(n, (0.0, 0.0));
  for (int k = 0; k < n ~/ 2; k++) {
    final angle = sign * 2 * pi * k / n;
    final w = (cos(angle), sin(angle));
    final t = cmul(w, odd[k]);
    result[k]           = cadd(even[k], t);
    result[k + n ~/ 2]  = csub(even[k], t);
  }
  return result;
}

List<C> ifft(List<C> x) {
  final n = x.length;
  // Conjugate, forward FFT, conjugate, scale by 1/n.
  final conj  = x.map(cconj).toList();
  final fwdConj = fft(conj);
  return fwdConj.map((c) => cscale(cconj(c), 1.0 / n)).toList();
}

// --- polynomial multiplication using FFT ------------------------------

List<int> polyMul(List<int> a, List<int> b) {
  // Pad to next power of 2 of length ≥ a.length + b.length - 1.
  int n = 1;
  while (n < a.length + b.length - 1) n <<= 1;

  final ca = [...a.map((v) => (v.toDouble(), 0.0)), ...List.filled(n - a.length, (0.0, 0.0))];
  final cb = [...b.map((v) => (v.toDouble(), 0.0)), ...List.filled(n - b.length, (0.0, 0.0))];

  final fa = fft(ca);
  final fb = fft(cb);
  final fc = [for (int i = 0; i < n; i++) cmul(fa[i], fb[i])];
  final res = ifft(fc);

  return res.sublist(0, a.length + b.length - 1)
      .map((c) => c.$1.round())
      .toList();
}

// --- naive O(n²) poly mul for verification ----------------------------

List<int> polyMulNaive(List<int> a, List<int> b) {
  final result = List<int>.filled(a.length + b.length - 1, 0);
  for (int i = 0; i < a.length; i++) {
    for (int j = 0; j < b.length; j++) {
      result[i + j] += a[i] * b[j];
    }
  }
  return result;
}

// --- demo --------------------------------------------------------------

void main() {
  print('=== Cooley-Tukey FFT ===\n');

  // Basic FFT round-trip.
  final signal = [1.0, 2.0, 3.0, 4.0].map((v) => (v, 0.0) as C).toList();
  final spectrum = fft(signal);
  final recovered = ifft(spectrum);

  print('Original  : ${signal.map((c) => c.$1.toStringAsFixed(2)).join(", ")}');
  print('FFT       : ${spectrum.map(cfmt).join(", ")}');
  print('IFFT      : ${recovered.map((c) => c.$1.toStringAsFixed(2)).join(", ")}');
  print('Round-trip: ${signal.map((c) => c.$1.round()).join(", ") == recovered.map((c) => c.$1.round()).join(", ")}\n');

  // Polynomial multiplication.
  // [1,2,3] represents 1 + 2x + 3x²
  // [4,5,6] represents 4 + 5x + 6x²
  // Product  = 4 + 13x + 28x² + 27x³ + 18x⁴
  final a = [1, 2, 3];
  final b = [4, 5, 6];
  final fftResult   = polyMul(a, b);
  final naiveResult = polyMulNaive(a, b);

  print('Polynomial multiplication:');
  print('  A = ${a}  (coefficients of 1 + 2x + 3x²)');
  print('  B = ${b}  (coefficients of 4 + 5x + 6x²)');
  print('  FFT result   : $fftResult');
  print('  Naive result : $naiveResult');
  print('  Match: ${fftResult.toString() == naiveResult.toString()}\n');

  // Larger example to show O(n log n) vs O(n²) difference.
  final size = 256;
  final bigA = List<int>.generate(size, (i) => i + 1);
  final bigB = List<int>.generate(size, (i) => size - i);

  final sw1 = Stopwatch()..start();
  final r1 = polyMul(bigA, bigB); sw1.stop();

  final sw2 = Stopwatch()..start();
  final r2 = polyMulNaive(bigA, bigB); sw2.stop();

  print('Large poly (n=$size each):');
  print('  FFT:   ${sw1.elapsedMicroseconds} µs  → result[0]=${r1[0]}, result[${r1.length-1}]=${r1.last}');
  print('  Naive: ${sw2.elapsedMicroseconds} µs  → result[0]=${r2[0]}, result[${r2.length-1}]=${r2.last}');
  print('  Results match: ${r1.toString() == r2.toString()}');
}
