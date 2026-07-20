// Tally the occurrences of each word in a body of text.
//
// Splits on any non-word character (regex \W+) to handle punctuation
// and multiple spaces uniformly. Lowercases everything so "The" and
// "the" merge. For serious NLP use a proper tokenizer — this treats
// "don't" as two tokens, gets confused by hyphenated words, and
// ignores morphology (running, runs, run all count separately).
//
// The `??` fallback pattern is the standard Dart idiom for
// "increment count in map or start at 0". Complexity: O(n) time and
// O(unique-words) space. Building block for word clouds, term
// frequency in TF-IDF (which then divides by document count), and
// basic search indexing.

Map<String, int> wordCount(String text) {
  final counts = <String, int>{};
  final words = text
      .toLowerCase()
      .split(RegExp(r'\W+'))
      .where((w) => w.isNotEmpty);
  for (final w in words) {
    counts[w] = (counts[w] ?? 0) + 1;
  }
  return counts;
}

void main() {
  const text = 'The quick brown fox jumps over the lazy dog. The dog barks.';
  final counts = wordCount(text);
  final sorted = counts.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  for (final e in sorted) {
    print('${e.key}: ${e.value}');
  }
}
