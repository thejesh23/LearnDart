// Build Huffman codes from a text: the two least-frequent nodes are
// merged repeatedly until a single tree remains.
class _Node implements Comparable<_Node> {
  final int freq;
  final String? char;
  final _Node? left;
  final _Node? right;
  _Node(this.freq, {this.char, this.left, this.right});
  @override
  int compareTo(_Node o) => freq.compareTo(o.freq);
}

Map<String, String> huffmanCodes(String text) {
  final freqs = <String, int>{};
  for (final ch in text.split('')) {
    freqs[ch] = (freqs[ch] ?? 0) + 1;
  }
  final nodes = <_Node>[
    for (final e in freqs.entries) _Node(e.value, char: e.key),
  ]..sort();
  while (nodes.length > 1) {
    final a = nodes.removeAt(0);
    final b = nodes.removeAt(0);
    final merged = _Node(a.freq + b.freq, left: a, right: b);
    int i = 0;
    while (i < nodes.length && nodes[i].freq < merged.freq) i++;
    nodes.insert(i, merged);
  }

  final codes = <String, String>{};
  void assign(_Node n, String code) {
    if (n.char != null) {
      codes[n.char!] = code.isEmpty ? '0' : code;
      return;
    }
    if (n.left != null) assign(n.left!, '${code}0');
    if (n.right != null) assign(n.right!, '${code}1');
  }
  if (nodes.isNotEmpty) assign(nodes.first, '');
  return codes;
}

void main() {
  final codes = huffmanCodes('this is an example for huffman encoding');
  final sorted = codes.entries.toList()
    ..sort((a, b) => a.value.length.compareTo(b.value.length));
  for (final e in sorted) print('"${e.key}" -> ${e.value}');
}
