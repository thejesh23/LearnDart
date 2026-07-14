Map<String, int> characterFrequency(String s) {
  final counts = <String, int>{};
  for (final ch in s.split('')) {
    counts[ch] = (counts[ch] ?? 0) + 1;
  }
  return counts;
}

void main() {
  final freq = characterFrequency('mississippi');
  print(freq); // {m: 1, i: 4, s: 4, p: 2}
}
