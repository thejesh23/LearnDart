// Isolate-backed parallel map — like concurrency/parallel_map.dart
// but each unit of work runs in a *separate isolate* so multiple
// CPU cores actually get used. This is what you want for
// image processing, hashing, JSON parsing at scale, physics
// simulation — any workload where the bottleneck is CPU, not I/O.
//
// The recipe:
//   1. Take a list of inputs.
//   2. For each input, spawn a fresh isolate via `Isolate.run`
//      (which handles spawn / execute / tear-down automatically
//      as of Dart 2.19+).
//   3. Cap the number in flight with a semaphore — otherwise you
//      spawn N isolates for N inputs and drown in memory.
//   4. Collect results in order.
//
// For very fine-grained tasks the isolate-spawn overhead
// dominates; keep each job in the millisecond-and-up range or
// batch inputs together. For really long-lived pipelines with
// small jobs, use a worker pool
// (concurrency/isolate_worker_pool.dart) which pays spawn cost
// once and then reuses workers.
import 'dart:async';
import 'dart:isolate';
import 'dart:collection';

class _Semaphore {
  int _permits;
  final _waiters = Queue<Completer<void>>();
  _Semaphore(this._permits);
  Future<void> acquire() {
    if (_permits > 0) { _permits--; return Future.value(); }
    final c = Completer<void>();
    _waiters.add(c);
    return c.future;
  }
  void release() {
    if (_waiters.isNotEmpty) { _waiters.removeFirst().complete(); }
    else _permits++;
  }
}

Future<List<R>> isolateParallelMap<T, R>(
    List<T> items,
    R Function(T) mapper,
    {int concurrency = 4}) async {
  final sem = _Semaphore(concurrency);
  final futures = <Future<R>>[];
  for (final item in items) {
    futures.add(() async {
      await sem.acquire();
      try {
        return await Isolate.run(() => mapper(item));
      } finally {
        sem.release();
      }
    }());
  }
  return Future.wait(futures);
}

/// CPU-bound example: sum of squares up to n. In real code you'd
/// replace with hashing, image resizing, or similar.
int _work(int n) {
  int total = 0;
  for (int i = 1; i <= n; i++) total += i * i;
  return total;
}

Future<void> main() async {
  final inputs = [100000, 200000, 300000, 400000];
  final sw = Stopwatch()..start();
  final results = await isolateParallelMap(inputs, _work, concurrency: 4);
  sw.stop();
  print(results);
  print('parallel elapsed ≈ ${sw.elapsedMilliseconds} ms');
  // On a multi-core machine, roughly time-of-longest instead of sum-of-all.
}
