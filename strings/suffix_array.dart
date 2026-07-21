// Suffix array — a sorted array of all suffixes of a string, stored
// as their starting indices. Together with the LCP (Longest Common
// Prefix) array it enables O(n + occ) pattern search, O(n) longest
// repeated substring, and is the backbone of data-compression tools
// (bzip2 uses suffix sorting) and genome-assembly pipelines.
//
// Why not suffix trees?
//   Suffix trees have O(n) build and query but carry 20–40 bytes of
//   overhead per node. Suffix arrays need O(n) space (one int per
//   suffix) and build in O(n log² n) or O(n) — in practice suffix
//   arrays are preferred for their cache efficiency and simplicity.
//
// Construction — O(n log² n) prefix-doubling (Manber & Myers):
//   Round 0: rank each suffix by its first character.
//   Round k: each suffix's sort key is the pair
//             (rank[i], rank[i + 2^(k-1)]).
//   Sort by key pairs, reassign dense ranks. Repeat until all ranks
//   are distinct (or 2^k ≥ n). log n rounds × O(n log n) sort = O(n log² n).
//
// LCP array — O(n) Kasai's algorithm:
//   Process suffixes in *text* order, not sorted order. Key insight:
//   lcp(suffix i, its left neighbour in SA) ≥ lcp(suffix i-1, ...) - 1.
//   This lets h decrease by at most 1 per step → total work O(n).
//
// Longest repeated substring demo: the maximum value in the LCP array
// corresponds to the longest string that appears ≥ twice in the text.

List<int> buildSuffixArray(String s) {
  final n = s.length;
  if (n == 0) return [];

  // Initial rank = character code; suffix array = [0..n-1] sorted by s[i].
  var rank = List<int>.generate(n, (i) => s.codeUnitAt(i));
  var sa   = List<int>.generate(n, (i) => i)
    ..sort((a, b) => rank[a] - rank[b]);

  for (int gap = 1; gap < n; gap *= 2) {
    // Comparator for round with this gap: compare (rank[i], rank[i+gap]).
    int compare(int a, int b) {
      if (rank[a] != rank[b]) return rank[a] - rank[b];
      final ra = a + gap < n ? rank[a + gap] : -1;
      final rb = b + gap < n ? rank[b + gap] : -1;
      return ra - rb;
    }
    sa.sort(compare);

    // Reassign ranks densely.
    final tmp = List<int>.filled(n, 0);
    tmp[sa[0]] = 0;
    for (int i = 1; i < n; i++) {
      tmp[sa[i]] = tmp[sa[i - 1]] + (compare(sa[i], sa[i - 1]) != 0 ? 1 : 0);
    }
    rank = tmp;
    if (rank[sa[n - 1]] == n - 1) break;  // all ranks unique → done
  }
  return sa;
}

// Kasai's O(n) LCP array.
// lcp[i] = longest common prefix between s[sa[i-1]..] and s[sa[i]..].
// lcp[0] is undefined (conventionally 0).
List<int> buildLCP(String s, List<int> sa) {
  final n = s.length;
  final rank = List<int>.filled(n, 0);
  for (int i = 0; i < n; i++) rank[sa[i]] = i;

  final lcp = List<int>.filled(n, 0);
  int h = 0;
  for (int i = 0; i < n; i++) {
    if (rank[i] > 0) {
      final j = sa[rank[i] - 1];
      while (i + h < n && j + h < n && s[i + h] == s[j + h]) h++;
      lcp[rank[i]] = h;
      if (h > 0) h--;
    }
  }
  return lcp;
}

String longestRepeatedSubstring(String s) {
  if (s.length < 2) return '';
  final sa  = buildSuffixArray(s);
  final lcp = buildLCP(s, sa);
  int maxLen = 0, maxIdx = 0;
  for (int i = 1; i < lcp.length; i++) {
    if (lcp[i] > maxLen) { maxLen = lcp[i]; maxIdx = i; }
  }
  return maxLen == 0 ? '' : s.substring(sa[maxIdx], sa[maxIdx] + maxLen);
}

void main() {
  const s = 'banana';
  final sa  = buildSuffixArray(s);
  final lcp = buildLCP(s, sa);

  print('String: "$s"\n');
  print('Suffix array (index → suffix):');
  for (final i in sa) print('  $i  "${s.substring(i)}"');

  print('\nLCP array:');
  for (int i = 0; i < lcp.length; i++) {
    print('  lcp[$i] = ${lcp[i]}  (with "${s.substring(sa[i])}")');
  }

  print('\nLongest repeated substring: "${longestRepeatedSubstring(s)}"');
  // Expected: "ana" (appears at positions 1 and 3)

  // Second example
  const s2 = 'abracadabra';
  print('\nLongest repeated substring in "$s2": "${longestRepeatedSubstring(s2)}"');
  // Expected: "abra"
}
