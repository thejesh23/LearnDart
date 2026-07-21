// MinHash — estimates the Jaccard similarity between two sets using
// a fixed-size signature vector, without materialising the full sets.
//
// Jaccard similarity:  J(A, B) = |A ∩ B| / |A ∪ B|
//   Perfect for "how similar are these two documents?" when a
//   document is modelled as the set of its k-shingles (substrings
//   of length k). Used by Google's Simhash, near-duplicate detection
//   in web crawlers, collaborative filtering, and LSH.
//
// The MinHash trick (Broder, 1997):
//   For a random hash function h, Pr[ min_{x∈A}(h(x)) = min_{x∈B}(h(x)) ]
//   = J(A, B).  Why? Because h is equally likely to put any element
//   of A∪B at the minimum; it lands in A∩B with probability |A∩B|/|A∪B|.
//
// Signature matrix:
//   Use k independent hash functions h_1 … h_k. For each set S,
//   the signature is the vector [min_{x∈S} h_i(x)  for each i].
//   Estimate J(A,B) by counting the fraction of positions where
//   sig(A)[i] = sig(B)[i].
//
// Error: variance of the estimate is J(1-J)/k.
//   k=100 → standard deviation ≈ 0.05 at J=0.5.
//   k=400 → standard deviation ≈ 0.025.
//
// Locality-Sensitive Hashing (LSH) extension (not shown here):
//   Band the signature into b bands of r rows each.
//   Two sets become candidates if they match on any one band entirely.
//   This finds near-duplicates in O(n) instead of O(n²) comparisons.

import 'dart:math';

const _p = 0x7fffffff; // Mersenne prime 2^31 - 1

class MinHash {
  final int numHashes;
  final List<(int a, int b)> _params;

  MinHash({this.numHashes = 128, int seed = 42}) :
      _params = () {
        final rng = Random(seed);
        return [
          for (int i = 0; i < numHashes; i++)
            (rng.nextInt(_p - 1) + 1, rng.nextInt(_p))
        ];
      }();

  int _fnv1a(String s) {
    int h = 0x811c9dc5;
    for (final c in s.codeUnits) { h ^= c; h = (h * 0x01000193) & 0xFFFFFFFF; }
    return h & 0x7FFFFFFF; // keep positive
  }

  /// Returns the MinHash signature of [items]: a list of [numHashes] integers.
  List<int> signature(Iterable<String> items) {
    final sig = List<int>.filled(numHashes, _p);
    for (final item in items) {
      final x = _fnv1a(item);
      for (int i = 0; i < numHashes; i++) {
        final (a, b) = _params[i];
        final hv = ((a * x + b) % _p);
        if (hv < sig[i]) sig[i] = hv;
      }
    }
    return sig;
  }

  /// Estimates Jaccard similarity from two pre-computed signatures.
  static double jaccardFromSigs(List<int> s1, List<int> s2) {
    assert(s1.length == s2.length);
    int matches = 0;
    for (int i = 0; i < s1.length; i++) {
      if (s1[i] == s2[i]) matches++;
    }
    return matches / s1.length;
  }

  /// Exact Jaccard similarity for verification (compares two sets directly).
  static double exactJaccard(Set<String> a, Set<String> b) {
    final inter = a.intersection(b).length;
    final union = a.union(b).length;
    return union == 0 ? 1.0 : inter / union;
  }
}

// K-shingles: all substrings of length k in a document.
Set<String> shingles(String doc, int k) {
  final out = <String>{};
  final words = doc.toLowerCase().split(RegExp(r'\s+'));
  for (int i = 0; i + k <= words.length; i++) {
    out.add(words.sublist(i, i + k).join(' '));
  }
  return out;
}

void main() {
  final mh = MinHash(numHashes: 200);

  final docs = {
    'A': 'the quick brown fox jumps over the lazy dog',
    'B': 'the quick brown fox leaps over a lazy dog',   // similar to A
    'C': 'pack my box with five dozen liquor jugs',     // very different
    'D': 'the quick brown fox jumps over the lazy dog', // identical to A
  };

  final sigs = docs.map((k, v) => MapEntry(k, mh.signature(shingles(v, 2))));
  final sets = docs.map((k, v) => MapEntry(k, shingles(v, 2)));

  print('Pairwise Jaccard similarity (2-shingles):');
  print('${"pair".padRight(8)}  exact   minhash  diff');
  final pairs = [('A','B'), ('A','C'), ('A','D'), ('B','C')];
  for (final (x, y) in pairs) {
    final exact = MinHash.exactJaccard(sets[x]!, sets[y]!);
    final est   = MinHash.jaccardFromSigs(sigs[x]!, sigs[y]!);
    print('  ($x,$y)   ${exact.toStringAsFixed(3)}   ${est.toStringAsFixed(3)}'
          '    ${(est - exact).abs().toStringAsFixed(3)}');
  }
  // A vs D (identical): exact=1.0, minhash≈1.0
  // A vs B (similar):   exact≈0.5, minhash≈0.5
  // A vs C (different): exact≈0.0, minhash≈0.0
}
