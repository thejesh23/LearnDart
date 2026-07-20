// Future pool — a long-lived worker pool for async tasks. Where
// `parallelMap` (concurrency/parallel_map.dart) is a one-shot
// "map with a cap", `FuturePool` is stateful and accepts new work
// over its lifetime:
//
//   final pool = FuturePool(concurrency: 4);
//   final a = pool.submit(() async => fetch(url1));
//   final b = pool.submit(() async => fetch(url2));
//   // ... later, from anywhere:
//   final c = pool.submit(() async => fetch(url3));
//   await pool.drain();     // wait for everything currently queued
//   await pool.close();     // no more submissions accepted
//
// The pool holds a semaphore of `concurrency` permits and a queue
// of pending closures; workers grab permits, execute a task, and
// release. Each `.submit` returns a Future that resolves to the
// task's result (or errors if the task threw).
//
// Use case: an HTTP client that caps in-flight requests, or a
// background job runner inside a long-lived service.
import 'dart:async';
import 'dart:collection';

class FuturePool {
  final int concurrency;
  int _running = 0;
  bool _closed = false;
  final Queue<void Function()> _queue = Queue();

  FuturePool({this.concurrency = 4}) {
    if (concurrency < 1) throw ArgumentError('concurrency must be ≥ 1');
  }

  Future<T> submit<T>(Future<T> Function() task) {
    if (_closed) throw StateError('pool is closed');
    final c = Completer<T>();
    void run() async {
      try {
        c.complete(await task());
      } catch (e, st) {
        c.completeError(e, st);
      } finally {
        _running--;
        _pump();
      }
    }
    _queue.add(run);
    _pump();
    return c.future;
  }

  void _pump() {
    while (_running < concurrency && _queue.isNotEmpty) {
      _running++;
      _queue.removeFirst().call();
    }
  }

  /// Wait for everything currently submitted to finish.
  Future<void> drain() async {
    while (_running > 0 || _queue.isNotEmpty) {
      await Future<void>.delayed(const Duration(milliseconds: 1));
    }
  }

  Future<void> close() async {
    _closed = true;
    await drain();
  }
}

Future<void> main() async {
  final pool = FuturePool(concurrency: 3);
  final results = <int>[];
  for (int i = 0; i < 8; i++) {
    pool.submit<void>(() async {
      await Future<void>.delayed(Duration(milliseconds: 20 + (i * 5) % 30));
      results.add(i);
    });
  }
  await pool.close();
  print(results); // some interleaved permutation of 0..7
}
