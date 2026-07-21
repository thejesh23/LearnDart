// Patricia trie (radix tree / compressed trie) — each edge stores a
// *substring* rather than a single character. Nodes with only one
// child are merged with their parent, so the total node count equals
// the number of inserted strings, not the sum of their lengths.
//
// Compared with a standard trie (trie.dart):
//   Standard trie: O(M) nodes per string, one character per edge.
//   Patricia trie:  one node per string (plus internal branch nodes),
//                  one edge label per shared prefix fragment.
//   For a dictionary of N words with average length M, the Patricia
//   trie uses O(N) nodes vs O(N*M) for the standard trie.
//
// This is the structure inside Linux's route lookup (ip_fib_trie),
// most DNS resolvers' zone trees, and compressed inverted indexes.
//
// Operations (all O(M) where M = key length):
//   insert(key)  — split an existing edge at the first differing
//                  character, creating an internal branch node.
//   search(key)  — walk edges, matching label characters exactly.
//   startsWith   — returns all keys with a given prefix.
//
// This implementation stores string keys; the same logic applies to
// bit-level keys (the original Patricia paper used binary keys).

class _RadixNode {
  // Map from first character of edge label → (label, child).
  // Using first-char as the key works because no two edges from the
  // same node can share a first character (otherwise they'd be merged).
  final Map<String, (String, _RadixNode)> edges = {};
  bool isEnd = false;  // true if a key ends exactly here
}

class PatriciaTrie {
  final _RadixNode _root = _RadixNode();

  void insert(String key) {
    _RadixNode cur = _root;
    String remaining = key;

    while (remaining.isNotEmpty) {
      final firstCh = remaining[0];
      final entry = cur.edges[firstCh];

      if (entry == null) {
        // No edge starting with this character — create a leaf.
        cur.edges[firstCh] = (remaining, _RadixNode()..isEnd = true);
        return;
      }

      final (label, child) = entry;
      final commonLen = _commonPrefix(remaining, label);

      if (commonLen == label.length) {
        // Entire label matched — descend into child.
        remaining = remaining.substring(commonLen);
        if (remaining.isEmpty) { child.isEnd = true; return; }
        cur = child;
        continue;
      }

      // Partial match — split the edge at commonLen.
      final sharedPart  = label.substring(0, commonLen);
      final oldSuffix   = label.substring(commonLen);
      final newSuffix   = remaining.substring(commonLen);

      // New internal node
      final branch = _RadixNode();
      branch.edges[oldSuffix[0]] = (oldSuffix, child);

      if (newSuffix.isEmpty) {
        branch.isEnd = true;
      } else {
        branch.edges[newSuffix[0]] = (newSuffix, _RadixNode()..isEnd = true);
      }

      cur.edges[firstCh] = (sharedPart, branch);
      return;
    }
    cur.isEnd = true;
  }

  bool search(String key) {
    _RadixNode cur = _root;
    String remaining = key;

    while (remaining.isNotEmpty) {
      final entry = cur.edges[remaining[0]];
      if (entry == null) return false;
      final (label, child) = entry;
      if (!remaining.startsWith(label)) return false;
      remaining = remaining.substring(label.length);
      cur = child;
    }
    return cur.isEnd;
  }

  /// Returns all keys stored in the trie that begin with [prefix].
  List<String> startsWith(String prefix) {
    _RadixNode cur = _root;
    String remaining = prefix;

    while (remaining.isNotEmpty) {
      final entry = cur.edges[remaining[0]];
      if (entry == null) return [];
      final (label, child) = entry;
      if (remaining.length <= label.length) {
        if (!label.startsWith(remaining)) return [];
        // Prefix ends inside this edge — collect everything below child.
        final results = <String>[];
        _collect(child, prefix + label.substring(remaining.length), results);
        return results;
      }
      if (!remaining.startsWith(label)) return [];
      remaining = remaining.substring(label.length);
      cur = child;
    }
    // Prefix exactly matches a node — collect everything from here.
    final results = <String>[];
    _collect(cur, prefix, results);
    return results;
  }

  void _collect(_RadixNode node, String built, List<String> out) {
    if (node.isEnd) out.add(built);
    for (final (label, child) in node.edges.values) {
      _collect(child, built + label, out);
    }
  }

  static int _commonPrefix(String a, String b) {
    int i = 0;
    while (i < a.length && i < b.length && a[i] == b[i]) i++;
    return i;
  }
}

void main() {
  final trie = PatriciaTrie();

  for (final w in ['dart', 'dark', 'darkness', 'day', 'do', 'done', 'door']) {
    trie.insert(w);
  }

  const words = ['dart', 'dark', 'darkness', 'day', 'dawn', 'do', 'done', 'door', 'x'];
  print('Search results:');
  for (final w in words) {
    print('  search("$w") → ${trie.search(w)}');
  }

  print('\nPrefix completions:');
  for (final p in ['da', 'do', 'dar', 'z']) {
    print('  startsWith("$p") → ${trie.startsWith(p)}');
  }
}
