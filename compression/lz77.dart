// LZ77 — Sliding-Window Compression (Ziv & Lempel, 1977).
// The algorithm at the heart of DEFLATE, which powers zlib, gzip, ZIP,
// PNG, and HTTP's Content-Encoding: deflate.
//
// Intuition: text has repetition.  "abcabc" contains "abc" twice.
// Instead of emitting the second "abc" literally, emit a back-reference:
// (offset=3, length=3) meaning "copy 3 bytes starting 3 positions ago".
//
// Token format:  (offset, length, nextChar)
//   • offset  = how far back in the already-emitted output to look.
//   • length  = how many bytes to copy from there.
//   • nextChar= the literal byte AFTER the copied run (or after no match).
//   If no match: (0, 0, literal).
//
// Sliding window: we only look back `windowSize` bytes.  This bounds
// memory and lets decompression work in a streaming fashion.
//
// Decompression: read each token; if length>0, copy `length` bytes from
// output[cursor - offset .. cursor - offset + length]; then append nextChar.
// Note: length > offset is legal ("overlapping copy" / run-length);
// copy byte-by-byte so the pattern propagates correctly.
//
// Complexity: O(n × windowSize) naïve; O(n log n) with suffix trees.
// DEFLATE (gzip) pairs LZ77 with Huffman coding on the token stream.
//
// Relation to compression/burrows_wheeler.dart: BWT pre-sorts the data
// so that LZ77-style repetition is more local and compresses better.
//
// Run:  dart run compression/lz77.dart

typedef Lz77Token = (int offset, int length, String nextChar);

const int _windowSize = 255;
const int _maxMatchLen = 255;

// --- compression -------------------------------------------------------

List<Lz77Token> compress(String input) {
  final tokens = <Lz77Token>[];
  int pos = 0;

  while (pos < input.length) {
    int bestOffset = 0;
    int bestLength = 0;

    final windowStart = (pos - _windowSize).clamp(0, pos);

    // Search the window for the longest match.
    for (int start = windowStart; start < pos; start++) {
      int len = 0;
      while (len < _maxMatchLen &&
             pos + len < input.length &&
             input[start + (len % (pos - start))] == input[pos + len]) {
        len++;
      }
      if (len > bestLength) {
        bestLength = len;
        bestOffset = pos - start;
      }
    }

    final nextChar = (pos + bestLength < input.length)
        ? input[pos + bestLength]
        : '';
    tokens.add((bestOffset, bestLength, nextChar));
    pos += bestLength + 1;
  }

  return tokens;
}

// --- decompression -----------------------------------------------------

String decompress(List<Lz77Token> tokens) {
  final buf = StringBuffer();
  final out = <String>[];  // character array for back-reference indexing

  for (final (offset, length, nextChar) in tokens) {
    if (length > 0) {
      final start = out.length - offset;
      for (int i = 0; i < length; i++) {
        final ch = out[start + i];   // byte-by-byte so overlaps work
        out.add(ch);
        buf.write(ch);
      }
    }
    if (nextChar.isNotEmpty) {
      out.add(nextChar);
      buf.write(nextChar);
    }
  }

  return buf.toString();
}

// --- helpers -----------------------------------------------------------

int _compressedBits(List<Lz77Token> tokens) {
  // Each token: 8-bit offset + 8-bit length + 8-bit char = 24 bits.
  // Literal-only token is also 24 bits; DEFLATE uses Huffman on top to
  // compress the token stream further.  We just count raw token bits.
  return tokens.length * 24;
}

// --- demo --------------------------------------------------------------

void main() {
  print('=== LZ77 Sliding-Window Compression ===\n');

  final testCases = [
    'abcabcabc',
    'aaaaaaaaaa',
    'the quick brown fox jumps over the lazy dog',
    'abracadabra',
    'AABABABABABABABABABABABABAB',
  ];

  for (final input in testCases) {
    final tokens = compress(input);
    final decompressed = decompress(tokens);
    final originalBits = input.length * 8;
    final compressedBitCount = _compressedBits(tokens);
    final ratio = (compressedBitCount / originalBits * 100).toStringAsFixed(0);

    print('Input      : "$input"');
    print('Tokens     : ${tokens.length}  → $compressedBitCount bits '
        '(original: $originalBits bits, $ratio% of original)');
    for (final t in tokens) {
      final (off, len, ch) = t;
      if (len == 0) {
        print('  (literal "$ch")');
      } else {
        print('  (offset=$off, len=$len, next="${ch.isNotEmpty ? ch : "∅"}")');
      }
    }
    print('Decompressed: "$decompressed"');
    print('Round-trip OK: ${input == decompressed}\n');
  }
}
