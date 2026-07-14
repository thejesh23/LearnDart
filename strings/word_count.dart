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
