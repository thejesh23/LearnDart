// CRDTs — Conflict-free Replicated Data Types.
// Introduced by Shapiro et al. (2011, INRIA); now used in Riak, Redis
// CRDT types, Figma's multiplayer engine, and Automerge (the technology
// behind collaborative editing).
//
// The core insight: if your data type's merge operation is:
//   • Commutative:  merge(A,B) == merge(B,A)
//   • Associative:  merge(merge(A,B),C) == merge(A,merge(B,C))
//   • Idempotent:   merge(A,A) == A
// … then any replica can apply updates in any order and still converge
// to the same final state without coordination.  This is called a
// "join-semilattice" (each merge produces the least-upper-bound).
//
// GCounter (grow-only counter):
//   State = {nodeId → count}.  Value = sum of all slots.
//   Increment only touches the local node's slot.
//   Merge = component-wise max (per-slot maximum).
//   Monotone: value only ever increases → safe CvRDT (state-based).
//
// OR-Set (Observed-Remove Set):
//   Add gives the element a unique tag (nodeId + sequence number).
//   Remove deletes all of that element's currently known tags.
//   Contains = any tag for the element exists in the set.
//   Merge = union of tag sets (gives add-wins semantics: concurrent
//   add + remove → element present after merge).
//
// Relation to vector_clock.dart: each OR-Set tag is essentially a
// vector-clock event ID pinned to a specific nodeId and sequence.
//
// Run:  dart run distributed/crdt.dart

// --- GCounter ----------------------------------------------------------

class GCounter {
  final Map<String, int> _slots;

  GCounter([Map<String, int>? initial])
      : _slots = Map<String, int>.from(initial ?? {});

  void increment(String nodeId, [int amount = 1]) =>
      _slots[nodeId] = (_slots[nodeId] ?? 0) + amount;

  int get value => _slots.values.fold(0, (a, b) => a + b);

  GCounter merge(GCounter other) {
    final result = <String, int>{};
    final allKeys = {..._slots.keys, ...other._slots.keys};
    for (final k in allKeys) {
      result[k] = [_slots[k] ?? 0, other._slots[k] ?? 0]
          .reduce((a, b) => a > b ? a : b);
    }
    return GCounter(result);
  }

  GCounter copy() => GCounter(Map.from(_slots));

  @override
  String toString() {
    final s = _slots.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
    return '{${s.map((e) => '${e.key}:${e.value}').join(', ')}} = $value';
  }
}

// --- OR-Set ------------------------------------------------------------

/// An add-wins Observed-Remove Set.
class ORSet<T> {
  /// Tag = (nodeId, sequence) — unique per add operation.
  final Map<T, Set<(String, int)>> _tags;
  final Map<String, int> _seq;

  ORSet([Map<T, Set<(String, int)>>? tags, Map<String, int>? seq])
      : _tags = tags != null
            ? {for (final e in tags.entries) e.key: Set.from(e.value)}
            : {},
        _seq = Map.from(seq ?? {});

  void add(T element, String nodeId) {
    _seq[nodeId] = (_seq[nodeId] ?? 0) + 1;
    _tags.putIfAbsent(element, () => {}).add((nodeId, _seq[nodeId]!));
  }

  void remove(T element) => _tags.remove(element);

  bool contains(T element) =>
      _tags.containsKey(element) && _tags[element]!.isNotEmpty;

  Set<T> get elements =>
      _tags.entries.where((e) => e.value.isNotEmpty).map((e) => e.key).toSet();

  ORSet<T> merge(ORSet<T> other) {
    final allKeys = {..._tags.keys, ...other._tags.keys};
    final newTags = <T, Set<(String, int)>>{};
    for (final k in allKeys) {
      newTags[k] = {
        ...(_tags[k] ?? {}),
        ...(other._tags[k] ?? {}),
      };
    }
    // Merge sequence counters.
    final newSeq = <String, int>{};
    for (final k in {..._seq.keys, ...other._seq.keys}) {
      newSeq[k] = [_seq[k] ?? 0, other._seq[k] ?? 0]
          .reduce((a, b) => a > b ? a : b);
    }
    return ORSet(newTags, newSeq);
  }

  ORSet<T> copy() {
    final newTags = <T, Set<(String, int)>>{
      for (final e in _tags.entries) e.key: Set.from(e.value)
    };
    return ORSet(newTags, Map.from(_seq));
  }

  @override
  String toString() => 'ORSet{${elements.toList().join(", ")}}';
}

extension _ORSetPrint<T> on ORSet<T> {
  String display() {
    final sorted = elements.toList()
      ..sort((a, b) => a.toString().compareTo(b.toString()));
    return 'ORSet{${sorted.join(", ")}}';
  }
}

// --- demo --------------------------------------------------------------

void main() {
  print('=== CRDTs: GCounter & OR-Set ===\n');

  // --- GCounter demo ---
  print('--- GCounter (grow-only counter) ---');
  final c1 = GCounter();
  final c2 = GCounter();

  c1.increment('replica-1', 3);  // replica-1 sees 3 events
  c2.increment('replica-2', 5);  // replica-2 sees 5 events concurrently
  c1.increment('replica-1', 2);  // replica-1 sees 2 more

  print('replica-1: $c1');
  print('replica-2: $c2');

  final merged = c1.merge(c2);
  print('merged   : $merged');
  print('Merge is commutative: ${c1.merge(c2).value == c2.merge(c1).value}');
  print('Merge is idempotent:  ${merged.merge(merged).value == merged.value}\n');

  // --- OR-Set demo ---
  print('--- OR-Set (observed-remove set, add-wins) ---');
  final s1 = ORSet<String>();
  final s2 = ORSet<String>();

  s1.add('apple', 'node-1');
  s1.add('banana', 'node-1');
  s2.add('cherry', 'node-2');
  s2.add('apple', 'node-2');  // concurrent add of 'apple'

  // Concurrent: node-1 removes 'apple' while node-2 adds it.
  s1.remove('apple');

  print('node-1 elements: ${s1.display()}');
  print('node-2 elements: ${s2.display()}');

  final merged2 = s1.merge(s2);
  print('After merge     : ${merged2.display()}');
  print('apple present (add-wins): ${merged2.contains("apple")}');

  // Show any-order convergence.
  final mergedReverse = s2.merge(s1);
  print('Reverse merge   : ${mergedReverse.display()}');
  print('Same result either way: '
      '${merged2.elements.toString() == mergedReverse.elements.toString()}');
}
