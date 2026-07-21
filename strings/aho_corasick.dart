// Aho-Corasick automaton — extends the KMP failure-link idea from a
// single pattern to an entire dictionary. Finds *all* occurrences of
// *every* pattern simultaneously in a single O(N) pass over the text,
// where N is the text length.
//
// Build phase (O(M), M = sum of all pattern lengths):
//   1. Insert all patterns into a trie.
//   2. BFS to compute failure links: for each node v, the failure link
//      points to the longest proper suffix of v's path-label that is
//      also a prefix in the trie. This is exactly the KMP π-function
//      lifted to a trie.
//   3. Compute output links: at each node collect all patterns that
//      end here OR end at any node reachable via failure links.
//
// Search phase (O(N + total_matches)):
//   Walk the automaton character by character. On a miss, follow the
//   failure link (and then its failure link, etc.) until a transition
//   exists or the root is reached. At each position collect all
//   patterns via output links.
//
// Applications: antivirus scanners (ClamAV), intrusion detection
// systems (Snort), `grep -F` with multiple needles, genome alignment.
//
// Complexity: O(M) build (trie + BFS), O(N + occ) search.

import 'dart:collection';

class _AhoNode {
  final Map<String, _AhoNode> children = {};
  _AhoNode? failure;     // failure (suffix) link
  _AhoNode? output;      // output link: next node with a complete pattern
  List<String> patterns = [];  // patterns that end at this node
}

class AhoCorasick {
  final _root = _AhoNode();

  void addPattern(String pattern) {
    _AhoNode cur = _root;
    for (final ch in pattern.split('')) {
      cur = cur.children.putIfAbsent(ch, _AhoNode.new);
    }
    cur.patterns.add(pattern);
  }

  // Must be called after all patterns are added.
  void build() {
    final queue = Queue<_AhoNode>();
    // Root's children: failure link points to root.
    for (final child in _root.children.values) {
      child.failure = _root;
      queue.add(child);
    }

    while (queue.isNotEmpty) {
      final cur = queue.removeFirst();
      for (final MapEntry(key: ch, value: child) in cur.children.entries) {
        // Compute failure link for child: follow cur's failure links
        // until a node with a transition on ch is found (or root).
        _AhoNode fail = cur.failure!;
        while (fail != _root && !fail.children.containsKey(ch)) {
          fail = fail.failure!;
        }
        child.failure = fail.children[ch] ?? _root;
        if (child.failure == child) child.failure = _root; // avoid self-loop at root

        // Output link: if the failure node has patterns, point there;
        // otherwise inherit the failure node's output link.
        child.output = child.failure!.patterns.isNotEmpty
            ? child.failure
            : child.failure!.output;

        queue.add(child);
      }
    }
  }

  /// Returns a map of pattern → list of end-positions (0-based) in [text].
  Map<String, List<int>> search(String text) {
    final result = <String, List<int>>{};
    _AhoNode cur = _root;

    for (int i = 0; i < text.length; i++) {
      final ch = text[i];

      // Follow failure links until we find a transition or reach root.
      while (cur != _root && !cur.children.containsKey(ch)) {
        cur = cur.failure!;
      }
      cur = cur.children[ch] ?? _root;

      // Collect all patterns that end at position i.
      _AhoNode? node = cur.patterns.isNotEmpty ? cur : cur.output;
      while (node != null) {
        for (final p in node.patterns) {
          result.putIfAbsent(p, () => []).add(i);
        }
        node = node.output;
      }
    }
    return result;
  }
}

void main() {
  final ac = AhoCorasick();
  for (final p in ['he', 'she', 'his', 'hers']) ac.addPattern(p);
  ac.build();

  const text = 'ahishers';
  final hits = ac.search(text);

  print('Text: "$text"\n');
  for (final MapEntry(key: pattern, value: positions) in hits.entries) {
    for (final end in positions) {
      final start = end - pattern.length + 1;
      print('  "$pattern"  found at [$start, $end]');
    }
  }
  // "his"  found at [1, 3]
  // "he"   found at [4, 5]
  // "she"  found at [3, 5]
  // "hers" found at [4, 7]
}
