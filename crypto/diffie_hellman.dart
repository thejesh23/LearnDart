// Diffie-Hellman Key Exchange — Whitfield Diffie & Martin Hellman (1976).
// The first published public-key protocol; it lets two parties establish
// a shared secret over an *insecure* channel without ever transmitting
// the secret itself.
//
// Setup: agree publicly on a large prime p and a generator g (a primitive
// root mod p).  Both values can be standardised and reused.
//
// Exchange:
//   Alice: picks private a, sends A = g^a mod p.
//   Bob:   picks private b, sends B = g^b mod p.
//   Alice computes: s = B^a mod p = g^(ba) mod p.
//   Bob   computes: s = A^b mod p = g^(ab) mod p.
//   Both arrive at the same shared secret s.
//
// Security: an eavesdropper sees g, p, A=g^a mod p, B=g^b mod p but
// must solve the Discrete Logarithm Problem to recover a or b —
// believed to be hard for large p (~2048 bits in FFDHE groups).
//
// Safe primes: p = 2q+1 where q is also prime.  This ensures that the
// subgroup of order q has no small-subgroup attacks.
//
// Relation to rsa.dart: both rely on modular exponentiation; RSA uses
// factorisation hardness, DH uses discrete-log hardness.
//
// Run:  dart run crypto/diffie_hellman.dart
import 'dart:math';

// --- parameter records -------------------------------------------------

typedef DhParams   = ({BigInt p, BigInt g});
typedef DhKeyPair  = ({BigInt privateKey, BigInt publicKey});

// --- key generation ----------------------------------------------------

DhKeyPair generateKeyPair(DhParams params, Random rng) {
  // Private key: random in [2, p-2].
  final byteCount = (params.p.bitLength + 7) ~/ 8;
  BigInt priv;
  do {
    final bytes = List<int>.generate(byteCount, (_) => rng.nextInt(256));
    priv = bytes.fold(BigInt.zero, (acc, b) => (acc << 8) | BigInt.from(b));
    priv = priv % (params.p - BigInt.two) + BigInt.two;
  } while (priv < BigInt.two);
  final pub = params.g.modPow(priv, params.p);
  return (privateKey: priv, publicKey: pub);
}

BigInt computeSharedSecret(
    BigInt theirPublic, BigInt myPrivate, DhParams params) =>
    theirPublic.modPow(myPrivate, params.p);

// --- demo primes -------------------------------------------------------

// A 256-bit safe prime (p = 2q+1) for demonstration.
// Production uses RFC 3526 Group 14 (2048-bit) or Group 16 (4096-bit).
final _demoP = BigInt.parse(
  'FFFFFFFFFFFFFFFFC90FDAA22168C234C4C6628B80DC1CD1'
  '29024E088A67CC74020BBEA63B139B22514A08798E3404DD'
  'EF9519B3CD3A431B302B0A6DF25F14374FE1356D6D51C245'
  'E485B576625E7EC6F44C42E9A637ED6B0BFF5CB6F406B7ED'
  'EE386BFB5A899FA5AE9F24117C4B1FE649286651ECE65381'
  'FFFFFFFFFFFFFFFF',
  radix: 16);
final _demoG = BigInt.two;

// Smaller 64-bit safe prime for fast output in the demo.
// p = 2×q+1 where q = 5809605995369958291 (prime).
final _smallP = BigInt.parse('11619211990739916583');
final _smallG = BigInt.from(2);

// --- demo --------------------------------------------------------------

void main() {
  print('=== Diffie-Hellman Key Exchange ===\n');

  final params = (p: _smallP, g: _smallG);
  final rng = Random(42);

  final alice = generateKeyPair(params, rng);
  final bob   = generateKeyPair(params, rng);

  print('Public parameters:');
  print('  p (prime)     = ${params.p}');
  print('  g (generator) = ${params.g}\n');

  print('Alice private key = ${alice.privateKey}');
  print('Alice public key  = ${alice.publicKey}');
  print('Bob   private key = ${bob.privateKey}');
  print('Bob   public key  = ${bob.publicKey}\n');

  final sharedAlice = computeSharedSecret(bob.publicKey,   alice.privateKey, params);
  final sharedBob   = computeSharedSecret(alice.publicKey, bob.privateKey,   params);

  print('Alice computes shared secret: $sharedAlice');
  print('Bob   computes shared secret: $sharedBob');
  print('Secrets match: ${sharedAlice == sharedBob}\n');

  print('--- What an eavesdropper sees ---');
  print('  p = ${params.p}');
  print('  g = ${params.g}');
  print('  A = ${alice.publicKey}  (g^a mod p)');
  print('  B = ${bob.publicKey}  (g^b mod p)');
  print('  To find shared secret, must solve: g^a ≡ A (mod p) for a.');
  print('  Discrete log is hard — infeasible for 2048-bit primes.\n');

  print('Note: this demo uses a 64-bit prime for speed; FFDHE Group 14');
  print('(RFC 3526) uses a 2048-bit safe prime for real security.');
}
