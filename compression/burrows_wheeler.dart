// Burrows-Wheeler Transform (BWT) — Michael Burrows & David Wheeler, 1994.
// BWT is the preprocessing step in bzip2, and is also used in DNA
// sequence alignment tools (BWA, Bowtie) for its FM-index properties.
//
// Forward transform:
//   1. Append a sentinel '$' (smallest character in the alphabet) to the input.
//   2. Form all N+1 cyclic rotations of the string.
//   3. Sort them lexicographically.
//   4. Take the last column L (the BWT output) and the row index of the
//      original string.
//
// Why does this help compression?
//   Letters that follow the same context in the original string cluster
//   together in L.  "banana$" → L = "annb$aa" — lots of runs.
//   Move-to-front coding + Huffman on L gives excellent ratios (bzip2).
//
// Inverse transform (reconstruct from L and index):
//   1. F = sorted(L) — the first column.
//   2. Build T-mapping: F[i] is "preceded by" L[i] in the original.
//   3. Starting from index (original row), follow the T-chain N times.
//   4. Strip the sentinel to recover the original string.
//
// Efficient construction: BWT = SA-based O(n log n) or O(n) via suffix
// array (see strings/ directory).  This demo uses the naive O(n²) sort.
//
// Complexity: O(n² log n) naïve (sorting n strings of length n);
//             O(n log n) via suffix array.
//
// Relation to compression/lz77.dart: bzip2 applies BWT → MTF → RLE →
// Huffman, while gzip applies LZ77 → Huffman.  BWT reorganises the data
// so RLE can exploit it; LZ77 exploits repetition directly.
//
// Run:  dart run compression/burrows_wheeler.dart

// --- forward BWT -------------------------------------------------------

/// Returns (transformedString, originalIndex).
(String, int) bwt(String s) {
  final t = '$s\$';       // append sentinel
  final n = t.length;

  // Build all rotations as index references (avoid O(n²) string copies).
  final rotations = List<int>.generate(n, (i) => i);
  rotations.sort((a, b) {
    for (int i = 0; i < n; i++) {
      final ca = t[(a + i) % n];
      final cb = t[(b + i) % n];
      if (ca != cb) return ca.compareTo(cb);
    }
    return 0;
  });

  final lastCol = rotations.map((r) => t[(r + n - 1) % n]).join();
  final origIdx = rotations.indexOf(0);   // row where rotation starts at pos 0
  return (lastCol, origIdx);
}

// --- inverse BWT -------------------------------------------------------

String ibwt(String transformed, int origIdx) {
  final n = transformed.length;
  final L = transformed.split('');

  // F = sorted L.
  final F = List<String>.from(L)..sort();

  // Build T-table: for each i, T[i] = j means F[i] is "preceded by" L[i],
  // and the next pointer in the chain is j.
  // We need to find, for each character occurrence in L, its matching
  // position in F (accounting for duplicates in order).
  final charCount = <String, int>{};
  final charStart = <String, int>{};

  // Count characters in L to find where each starts in F.
  for (final c in L) charCount[c] = (charCount[c] ?? 0) + 1;
  int offset = 0;
  for (final c in (charCount.keys.toList()..sort())) {
    charStart[c] = offset;
    offset += charCount[c]!;
  }

  // T[i] = position in F that corresponds to L[i].
  final seenCount = <String, int>{};
  final T = List<int>.filled(n, 0);
  for (int i = 0; i < n; i++) {
    final c = L[i];
    T[i] = charStart[c]! + (seenCount[c] ?? 0);
    seenCount[c] = (seenCount[c] ?? 0) + 1;
  }

  // Reconstruct: follow T chain from origIdx, N-1 times (skip sentinel).
  final result = <String>[];
  int idx = origIdx;
  for (int i = 0; i < n - 1; i++) {
    idx = T[idx];
    result.add(F[idx]);
  }
  return result.reversed.join();
}

// --- run-length encoding (show BWT output structure) ------------------

String rle(String s) {
  if (s.isEmpty) return '';
  final buf = StringBuffer();
  int count = 1;
  for (int i = 1; i < s.length; i++) {
    if (s[i] == s[i - 1]) {
      count++;
    } else {
      buf.write(count > 1 ? '$count${s[i-1]}' : s[i - 1]);
      count = 1;
    }
  }
  buf.write(count > 1 ? '$count${s[s.length-1]}' : s[s.length - 1]);
  return buf.toString();
}

// --- demo --------------------------------------------------------------

void main() {
  print('=== Burrows-Wheeler Transform ===\n');

  final inputs = ['banana', 'abracadabra', 'mississippi', 'aardvark'];

  for (final s in inputs) {
    final (transformed, idx) = bwt(s);
    final recovered = ibwt(transformed, idx);
    final rleOutput = rle(transformed);

    print('Input      : "$s"');
    print('BWT output : "$transformed"  (original row index: $idx)');
    print('RLE of BWT : "$rleOutput"  (${rleOutput.length} chars vs ${transformed.length})');
    print('Inverse BWT: "$recovered"');
    print('Round-trip : ${recovered == s}\n');
  }

  // Show that BWT clusters repeated characters.
  print('--- Why BWT helps compression ---');
  print('Original "mississippi" has runs: m-i-s-s-i-s-s-i-p-p-i');
  final (t, _) = bwt('mississippi');
  print('BWT output   : "$t"');
  print('BWT has runs : ${rle(t)}  (run-length coding is now very effective)');
  print('\nIn bzip2: BWT → move-to-front coding → run-length → Huffman.');
  print('LZ77 (see lz77.dart) is an alternative that finds repetition directly.');
}
