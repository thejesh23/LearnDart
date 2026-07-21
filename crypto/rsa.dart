// RSA — Rivest-Shamir-Adleman public-key cryptosystem (1977).
// Security rests on the integer factorisation problem: multiplying two
// large primes p and q is O(n²) but factoring n = p×q is believed to
// require sub-exponential time with the best known algorithms.
//
// Key generation:
//   1. Choose two distinct primes p and q.
//   2. n = p×q  (public modulus, ~2048 bits in production).
//   3. λ(n) = lcm(p-1, q-1)  (Carmichael's totient).
//   4. Choose public exponent e: conventionally 65537 (prime, sparse
//      binary, fast exponentiation, safe for standard padding).
//   5. d = e⁻¹ mod λ(n)  (private exponent via extended GCD).
//   Public key: (n, e).  Private key: (n, d).  Destroy p, q, λ(n).
//
// Encrypt: c = m^e mod n.
// Decrypt: m = c^d mod n  (works because e·d ≡ 1 mod λ(n)).
//
// Dart's `BigInt` handles arbitrary precision naturally; in production
// use 2048-bit random primes generated with a cryptographically secure
// RNG and primality testing (see number_theory/miller_rabin.dart).
// This demo uses tiny primes for readability — NEVER do this in production.
//
// Run:  dart run crypto/rsa.dart
import 'dart:math' show log, ln2;

// --- record type -------------------------------------------------------

typedef RsaKeyPair = ({BigInt n, BigInt e, BigInt d});

// --- math helpers ------------------------------------------------------

BigInt _gcd(BigInt a, BigInt b) {
  while (b != BigInt.zero) { final t = b; b = a % b; a = t; }
  return a;
}

BigInt _lcm(BigInt a, BigInt b) => (a ~/ _gcd(a, b)) * b;

/// Extended Euclidean algorithm → (gcd, x, y) with a·x + b·y = gcd.
(BigInt, BigInt, BigInt) _extGcd(BigInt a, BigInt b) {
  if (b == BigInt.zero) return (a, BigInt.one, BigInt.zero);
  final (g, x1, y1) = _extGcd(b, a % b);
  return (g, y1, x1 - (a ~/ b) * y1);
}

/// Modular inverse of a mod m (a and m must be coprime).
BigInt _modInverse(BigInt a, BigInt m) {
  final (g, x, _) = _extGcd(a % m, m);
  if (g != BigInt.one) throw ArgumentError('$a and $m are not coprime');
  return (x % m + m) % m;
}

// --- key generation ----------------------------------------------------

RsaKeyPair generateKeys(BigInt p, BigInt q) {
  final n = p * q;
  final lambda = _lcm(p - BigInt.one, q - BigInt.one);
  final e = BigInt.from(65537);
  final d = _modInverse(e, lambda);
  return (n: n, e: e, d: d);
}

// --- encrypt / decrypt -------------------------------------------------

BigInt encrypt(BigInt m, RsaKeyPair k) => m.modPow(k.e, k.n);
BigInt decrypt(BigInt c, RsaKeyPair k) => c.modPow(k.d, k.n);

// --- text helpers ------------------------------------------------------

/// Encode each char as its code-unit BigInt; encrypt individually.
/// Real RSA pads an entire message into one integer; this is for demo only.
List<BigInt> encryptText(String text, RsaKeyPair k) =>
    text.codeUnits.map((c) => encrypt(BigInt.from(c), k)).toList();

String decryptText(List<BigInt> ciphers, RsaKeyPair k) =>
    String.fromCharCodes(ciphers.map((c) => decrypt(c, k).toInt()));

// --- demo --------------------------------------------------------------

void main() {
  print('=== RSA Public-Key Cryptosystem ===\n');

  // Toy example — p=61, q=53 (classic textbook pair, n=3233).
  final toy = generateKeys(BigInt.from(61), BigInt.from(53));
  print('--- Toy keys (p=61, q=53) ---');
  print('n  = ${toy.n}   (public modulus)');
  print('e  = ${toy.e}   (public exponent)');
  print('d  = ${toy.d}  (private exponent)');
  final m = BigInt.from(42);
  final c = encrypt(m, toy);
  final m2 = decrypt(c, toy);
  print('\nPlaintext : $m');
  print('Ciphertext: $c');
  print('Decrypted : $m2  (matches: ${m == m2})\n');

  // Slightly larger demo primes.
  final p = BigInt.parse('1000000007');  // prime
  final q = BigInt.parse('998244353');   // prime (also NTT-friendly, see ntt.dart)
  final keys = generateKeys(p, q);
  print('--- Larger keys (1e9-scale primes) ---');
  print('n  = ${keys.n}');
  print('e  = ${keys.e}');
  print('d  = ${keys.d}');

  const msg = 'Dart';
  final cipher = encryptText(msg, keys);
  final plain  = decryptText(cipher, keys);
  print('\nOriginal  : $msg');
  print('Ciphertext: ${cipher.map((x) => x.toString()).join(', ')}');
  print('Decrypted : $plain  (matches: ${msg == plain})');

  print('\nNote: production RSA uses 2048-bit primes, OAEP padding, and');
  print('encrypts the whole message as one integer — not char-by-char.');
  final bits = (keys.n.bitLength).toDouble();
  print('This key is ${bits.round()} bits; production minimum is 2048 bits.');
}
