// Trie (prefix tree): each node is a step down a shared-prefix path.
// Storing all children as a Map<char, node> makes insert, contains,
// and prefix search all O(m) — proportional to the query length,
// independent of the number of stored strings.
//
// Wins over a hash set when: (1) many stored strings share prefixes
// (memory savings via sharing), (2) you need prefix queries
// (autocomplete, T9 predictive text, IP routing tables, dictionary
// word games), (3) you need in-order iteration by lexicographic
// order.
//
// The distinction between `contains` (whole word present?) and
// `startsWith` (any word starts with this prefix?) is what the
// isWord flag exists to disambiguate. See strings/kmp_search.dart
// for the pattern-matching equivalent on a single text.

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
