class _TrieNode {
  final Map<String, _TrieNode> children = {};
  bool isWord = false;
}

class Trie {
  final _TrieNode _root = _TrieNode();

  void insert(String word) {
    var node = _root;
    for (final ch in word.split('')) {
      node = node.children.putIfAbsent(ch, () => _TrieNode());
    }
    node.isWord = true;
  }

  bool contains(String word) {
    final n = _find(word);
    return n != null && n.isWord;
  }

  bool startsWith(String prefix) => _find(prefix) != null;

  _TrieNode? _find(String s) {
    var node = _root;
    for (final ch in s.split('')) {
      final next = node.children[ch];
      if (next == null) return null;
      node = next;
    }
    return node;
  }
}

void main() {
  final t = Trie();
  for (final w in ['apple', 'app', 'apex', 'bat']) t.insert(w);
  print(t.contains('app'));      // true
  print(t.contains('appl'));     // false
  print(t.startsWith('appl'));   // true
  print(t.startsWith('bar'));    // false
}
