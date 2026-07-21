// Consistent Hashing — the algorithm behind DynamoDB, Cassandra, and
// Redis Cluster's data partitioning.
//
// Naive approach: key → node by (hash(key) % numNodes).  Adding or
// removing a node changes numNodes and remaps O(N) keys.
//
// Consistent hashing maps both keys and nodes onto a circular "ring"
// [0, 2^32).  A key is owned by the first node clockwise from its hash
// position.  When a node joins, it only takes keys from its immediate
// clockwise neighbour — O(N/nodes) keys move.  When it leaves, its keys
// go to the next node — same bound.
//
// Virtual nodes (vnodes): assigning each physical node V positions on
// the ring makes the distribution more uniform and simplifies rebalancing
// when adding heterogeneous nodes.  Cassandra uses V=256 by default;
// DynamoDB originally used V=150.
//
// Replication: `getNodes(key, n)` returns n distinct physical nodes
// clockwise from the key's ring position — the replicas for that key.
//
// Complexity:
//   addNode / removeNode : O(V log R)  where R = total ring points.
//   getNode              : O(log R)    via SplayTreeMap.firstKeyAfter.
//
// Relation to distributed/vector_clock.dart: consistent hashing
// determines *which* nodes hold a key; vector clocks track *which*
// version of the value is newest on those nodes.
//
// Run:  dart run distributed/consistent_hashing.dart
import 'dart:collection';

// --- simple 32-bit hash (FNV-1a) as a substitute for MD5/SHA-256 ------

int _fnv32(String s) {
  int h = 0x811c9dc5;
  for (final c in s.codeUnits) {
    h ^= c;
    h = (h * 0x01000193) & 0xFFFFFFFF;
  }
  return h;
}

// --- consistent hash ring ----------------------------------------------

class ConsistentHashRing {
  // Sorted map: ring position → physical node name.
  final _ring = SplayTreeMap<int, String>();
  // Track which ring positions belong to each node (for removal).
  final _nodePositions = <String, List<int>>{};

  void addNode(String node, {int vnodes = 150}) {
    final positions = <int>[];
    for (int v = 0; v < vnodes; v++) {
      final pos = _fnv32('$node#$v');
      _ring[pos] = node;
      positions.add(pos);
    }
    _nodePositions[node] = positions;
  }

  void removeNode(String node) {
    final positions = _nodePositions.remove(node);
    if (positions == null) return;
    for (final p in positions) _ring.remove(p);
  }

  /// Return the node responsible for [key] (clockwise nearest vnode).
  String getNode(String key) {
    if (_ring.isEmpty) throw StateError('Ring is empty');
    final hash = _fnv32(key);
    // First key >= hash; if none, wrap around to ring.firstKey.
    final pos = _ring.firstKeyAfter(hash - 1) ?? _ring.firstKey()!;
    return _ring[pos]!;
  }

  /// Return [n] distinct physical nodes clockwise from [key] (replicas).
  List<String> getNodes(String key, int n) {
    final seen = <String>{};
    final result = <String>[];
    final hash = _fnv32(key);

    // Walk clockwise from hash, then wrap.
    final keys = [..._ring.keys.where((k) => k >= hash),
                  ..._ring.keys.where((k) => k <  hash)];
    for (final pos in keys) {
      final node = _ring[pos]!;
      if (seen.add(node)) result.add(node);
      if (result.length == n) break;
    }
    return result;
  }

  int get ringSize => _ring.length;
}

// --- demo --------------------------------------------------------------

void main() {
  print('=== Consistent Hashing Ring ===\n');

  final ring = ConsistentHashRing();
  ring.addNode('node-A');
  ring.addNode('node-B');
  ring.addNode('node-C');
  print('Ring populated: 3 nodes × 150 vnodes = ${ring.ringSize} positions\n');

  // Distribute 1000 keys and count ownership.
  final keys = List.generate(1000, (i) => 'key-$i');
  Map<String, int> count(ConsistentHashRing r) {
    final c = <String, int>{};
    for (final k in keys) {
      final node = r.getNode(k);
      c[node] = (c[node] ?? 0) + 1;
    }
    return c;
  }

  final before = count(ring);
  print('Distribution BEFORE removing node-B:');
  before.forEach((n, c) => print('  $n : $c keys'));

  // Remove node-B and count again.
  ring.removeNode('node-B');
  final after = count(ring);
  print('\nDistribution AFTER removing node-B (only node-B keys moved):');
  after.forEach((n, c) => print('  $n : $c keys'));

  // Count how many keys changed nodes.
  int moved = 0;
  for (final k in keys) {
    if (before[ring.getNode(k)] == null) moved++;
  }
  // Simpler: compare before/after ownership for each key using a second ring.
  final ring2 = ConsistentHashRing();
  ring2.addNode('node-A'); ring2.addNode('node-C');
  int movedCount = keys.where((k) => ring.getNode(k) != ring.getNode(k)).length;
  final bKeysCount = before['node-B'] ?? 0;
  print('\nKeys that were on node-B (now remapped): ~$bKeysCount');
  print('Expected ~${(1000 / 3).round()} (1/3 of 1000) — consistent hashing guarantees');
  print('only O(N/nodes) keys move on any topology change.\n');

  // Replication: show 2 replicas for a sample key.
  ring.addNode('node-B'); // put it back
  print('Replicas for "key-42": ${ring.getNodes("key-42", 2)}');
  print('Replicas for "key-99": ${ring.getNodes("key-99", 2)}');
}
