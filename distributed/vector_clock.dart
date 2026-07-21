// Vector Clocks — causal ordering in distributed systems.
// Introduced by Leslie Lamport (1978) and extended by Colin Fidge (1988).
//
// The problem: in a distributed system, clocks are not synchronised.
// Lamport's scalar logical clock gives a *total* order but loses
// concurrency information: if A happens-before B, LC(A) < LC(B), but
// LC(A) < LC(B) does NOT imply A happened-before B.
//
// Vector clocks assign each of N processes a vector of N counters.
//   • tick(pid): process pid increments its own slot before each local event.
//   • send(pid): tick, then attach the full vector to the outgoing message.
//   • receive(pid, msg): merge = component-wise max, then tick own slot.
//
// Comparison rules (VC(A) and VC(B) are two vector clocks):
//   A happens-before B  iff  VC(A)[i] ≤ VC(B)[i] for all i, with at
//                            least one strict inequality.
//   A == B (same event) iff  VC(A)[i] == VC(B)[i] for all i.
//   Concurrent           iff  neither A happens-before B nor B happens-before A.
//
// Use cases: version vectors in Amazon Dynamo (detect write conflicts),
// causal consistency in databases, debugging distributed traces.
//
// Relation to crdt.dart: CRDTs use merge semantics that are consistent
// with any vector-clock ordering; the CRDT merge function must produce
// the same result regardless of the delivery order.
//
// Run:  dart run distributed/vector_clock.dart

class VectorClock {
  final Map<String, int> _v;

  VectorClock([Map<String, int>? initial])
      : _v = Map<String, int>.from(initial ?? {});

  /// Increment own counter (local event).
  void tick(String pid) => _v[pid] = (_v[pid] ?? 0) + 1;

  /// Return a copy to attach to an outgoing message (after ticking pid).
  VectorClock send(String pid) {
    tick(pid);
    return VectorClock(Map.from(_v));
  }

  /// Merge incoming message clock, then tick own slot.
  void receive(String pid, VectorClock msg) {
    for (final entry in msg._v.entries) {
      _v[entry.key] = [_v[entry.key] ?? 0, entry.value].reduce(
          (a, b) => a > b ? a : b);
    }
    tick(pid);
  }

  /// True iff every component of this ≤ the corresponding component of [other],
  /// with at least one strictly less.
  bool happensBefore(VectorClock other) {
    final allKeys = {..._v.keys, ...other._v.keys};
    bool anyStrict = false;
    for (final k in allKeys) {
      final a = _v[k] ?? 0;
      final b = other._v[k] ?? 0;
      if (a > b) return false;      // this[k] > other[k] → not ≤
      if (a < b) anyStrict = true;
    }
    return anyStrict;
  }

  bool isConcurrent(VectorClock other) =>
      !happensBefore(other) && !other.happensBefore(this) && this != other;

  @override
  bool operator ==(Object other) {
    if (other is! VectorClock) return false;
    final allKeys = {..._v.keys, ...other._v.keys};
    return allKeys.every((k) => (_v[k] ?? 0) == (other._v[k] ?? 0));
  }

  @override
  int get hashCode => Object.hashAll(_v.entries.map((e) => '${e.key}:${e.value}'));

  @override
  String toString() {
    final sorted = _v.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
    return '{${sorted.map((e) => '${e.key}:${e.value}').join(', ')}}';
  }

  VectorClock copy() => VectorClock(Map.from(_v));
}

// --- demo --------------------------------------------------------------

void main() {
  print('=== Vector Clocks — Causal Ordering ===\n');

  // Three processes: alice, bob, carol.
  final vc = {'alice': VectorClock(), 'bob': VectorClock(), 'carol': VectorClock()};

  print('Initial clocks:');
  vc.forEach((p, c) => print('  $p: $c'));

  // alice does a local event.
  vc['alice']!.tick('alice');
  print('\nalice ticks (local write): ${vc['alice']}');

  // alice sends a message to bob.
  final msgAliceToBob = vc['alice']!.send('alice');
  print('alice sends to bob, clock: ${vc['alice']}  (message stamp: $msgAliceToBob)');

  // bob receives the message from alice, then does local work.
  vc['bob']!.receive('bob', msgAliceToBob);
  print('\nbob receives from alice: ${vc['bob']}');
  vc['bob']!.tick('bob');
  print('bob ticks (local event): ${vc['bob']}');

  // carol does two independent local events (no messages yet).
  vc['carol']!.tick('carol');
  vc['carol']!.tick('carol');
  print('\ncarol ticks twice (independent): ${vc['carol']}');

  // Capture snapshots for comparison.
  final aliceSnapshot = vc['alice']!.copy();
  final bobSnapshot   = vc['bob']!.copy();
  final carolSnapshot = vc['carol']!.copy();

  print('\n--- Causal relationships ---');
  print('alice: $aliceSnapshot');
  print('bob  : $bobSnapshot');
  print('carol: $carolSnapshot\n');

  print('alice → bob (alice happens-before bob): '
      '${aliceSnapshot.happensBefore(bobSnapshot)}');
  print('bob → alice (bob happens-before alice): '
      '${bobSnapshot.happensBefore(aliceSnapshot)}');
  print('alice ∥ carol (alice concurrent carol): '
      '${aliceSnapshot.isConcurrent(carolSnapshot)}');
  print('bob ∥ carol   (bob concurrent carol):   '
      '${bobSnapshot.isConcurrent(carolSnapshot)}');

  // carol hears from both alice and bob.
  vc['carol']!.receive('carol', aliceSnapshot);
  vc['carol']!.receive('carol', bobSnapshot);
  print('\nAfter carol receives alice+bob messages: ${vc['carol']}');
  print('Now alice → carol: ${aliceSnapshot.happensBefore(vc['carol']!)}');
  print('Now bob   → carol: ${bobSnapshot.happensBefore(vc['carol']!)}');
}
