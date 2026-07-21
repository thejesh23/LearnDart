// Arithmetic Coding — asymptotically optimal entropy compression.
// Developed independently by Rissanen & Langdon (1979) and Pasco (1976).
// Used in JPEG2000, HEVC/H.265, LZMA (7-Zip), CABAC (H.264 video).
//
// Key insight: Huffman assigns each symbol an integer number of bits.
// "e" (probability 0.13) gets 3 bits even though -log2(0.13)=2.94 bits.
// Arithmetic coding encodes the entire message as ONE fraction in [0,1),
// achieving exactly the Shannon entropy H = -Σ p(s) log2 p(s).
//
// Encoding:
//   Maintain an interval [low, high).  For each symbol, narrow it to
//   the sub-interval proportional to that symbol's probability:
//     new_low  = low + (high-low) × CDF(symbol)
//     new_high = low + (high-low) × CDF(symbol+1)
//   The encoded value is any number in the final [low, high).
//
// Decoding:
//   Given a fraction f in [0,1), find the symbol whose sub-interval
//   contains f, emit it, rescale: f = (f - CDF(s)) / P(s), repeat.
//
// Integer implementation: use fixed-point arithmetic with a 16-bit scale.
// When low and high converge on the top bit, emit that bit and rescale
// (the classic "bit-at-a-time" renormalisation, avoiding precision loss).
//
// This demo uses a simple order-0 (symbol-by-symbol) frequency model.
// Adaptive arithmetic coding updates probabilities as it goes (PPM).
//
// Complexity: O(n) encode and decode for n input symbols.
//
// Run:  dart run compression/arithmetic_coding.dart

// --- frequency model ---------------------------------------------------

class FrequencyModel {
  final Map<String, int> freq;
  final List<String> alphabet;
  final int total;

  FrequencyModel._(this.freq, this.alphabet, this.total);

  factory FrequencyModel(String input) {
    final f = <String, int>{};
    for (final c in input.split('')) f[c] = (f[c] ?? 0) + 1;
    // Add end-of-stream symbol.
    f['\x00'] = 1;
    final alpha = f.keys.toList()..sort();
    final tot = f.values.fold(0, (a, b) => a + b);
    return FrequencyModel._(f, alpha, tot);
  }

  /// Cumulative frequency of [symbol] (count of symbols < symbol).
  int cumFreq(String symbol) {
    int cum = 0;
    for (final s in alphabet) {
      if (s == symbol) break;
      cum += freq[s]!;
    }
    return cum;
  }

  /// Find the symbol whose cumulative range contains [scaledValue].
  String decode(int scaledValue, int scale) {
    int cum = 0;
    for (final s in alphabet) {
      cum += freq[s]!;
      if (scaledValue * total < cum * scale) return s;
    }
    return alphabet.last;
  }
}

// --- integer arithmetic coder (16-bit precision) ----------------------

const int _TOP    = 1 << 16;   // 65536
const int _HALF   = _TOP >> 1; // 32768
const int _QRTR   = _TOP >> 2; // 16384

class ArithmeticEncoder {
  int _low = 0;
  int _high = _TOP - 1;
  int _scale3 = 0;           // pending "almost-convergence" bits
  final List<int> _bits = [];

  void _emitBit(int bit) {
    _bits.add(bit);
    // Flush pending opposite bits accumulated during E3 scaling.
    while (_scale3 > 0) {
      _bits.add(1 - bit);
      _scale3--;
    }
  }

  void encode(FrequencyModel model, String input) {
    final symbols = input.split('')..add('\x00');  // end-of-stream
    for (final sym in symbols) {
      final range = _high - _low + 1;
      _high = _low + (range * (model.cumFreq(sym) + model.freq[sym]!)) ~/ model.total - 1;
      _low  = _low + (range * model.cumFreq(sym)) ~/ model.total;
      _renormalise();
    }
    // Flush: emit enough bits to distinguish the interval.
    _scale3++;
    if (_low < _QRTR) _emitBit(0); else _emitBit(1);
  }

  void _renormalise() {
    while (true) {
      if (_high < _HALF) {
        _emitBit(0);
        _low  = _low  * 2;
        _high = _high * 2 + 1;
      } else if (_low >= _HALF) {
        _emitBit(1);
        _low  = (_low  - _HALF) * 2;
        _high = (_high - _HALF) * 2 + 1;
      } else if (_low >= _QRTR && _high < 3 * _QRTR) {
        // E3: interval straddles the midpoint — defer a bit.
        _scale3++;
        _low  = (_low  - _QRTR) * 2;
        _high = (_high - _QRTR) * 2 + 1;
      } else {
        break;
      }
    }
  }

  List<int> get bits => List.unmodifiable(_bits);
}

// --- decoder -----------------------------------------------------------

class ArithmeticDecoder {
  String decode(FrequencyModel model, List<int> bits) {
    final result = StringBuffer();
    int low = 0, high = _TOP - 1;
    int value = 0;

    // Prime the value register with the first 16 bits.
    for (int i = 0; i < 16; i++) {
      value = (value << 1) | (i < bits.length ? bits[i] : 0);
    }
    int bitPos = 16;

    while (true) {
      final range  = high - low + 1;
      final scaled = ((value - low + 1) * model.total - 1) ~/ range;
      final sym    = model.decode(scaled, model.total);
      if (sym == '\x00') break;
      result.write(sym);

      high = low + (range * (model.cumFreq(sym) + model.freq[sym]!)) ~/ model.total - 1;
      low  = low + (range * model.cumFreq(sym)) ~/ model.total;

      // Mirror encoder renormalisation.
      while (true) {
        if (high < _HALF) {
          // nothing extra
        } else if (low >= _HALF) {
          value -= _HALF; low -= _HALF; high -= _HALF;
        } else if (low >= _QRTR && high < 3 * _QRTR) {
          value -= _QRTR; low -= _QRTR; high -= _QRTR;
        } else { break; }
        low  = low  * 2;
        high = high * 2 + 1;
        value = (value * 2) | (bitPos < bits.length ? bits[bitPos++] : 0);
      }
    }
    return result.toString();
  }
}

// --- demo --------------------------------------------------------------

void main() {
  print('=== Arithmetic Coding (integer, order-0 model) ===\n');

  final testCases = ['aababcaab', 'hello', 'aaaaaaa', 'abcdefg'];

  for (final input in testCases) {
    final model   = FrequencyModel(input);
    final encoder = ArithmeticEncoder();
    encoder.encode(model, input);
    final bits    = encoder.bits;

    final decoder = ArithmeticDecoder();
    final decoded = decoder.decode(model, bits);

    final naiveBits  = input.length * 8;
    final codedBits  = bits.length;
    final ratio = (codedBits / naiveBits * 100).toStringAsFixed(1);

    print('Input   : "$input"  (${naiveBits} bits naive)');
    print('Coded   : ${codedBits} bits  ($ratio% of naive)');
    print('Decoded : "$decoded"');
    print('OK      : ${decoded == input}\n');
  }

  print('Note: overhead is high for short strings because the model is');
  print('transmitted separately.  Arithmetic coding wins on long texts');
  print('where Huffman wastes fractional bits per symbol.');
}
