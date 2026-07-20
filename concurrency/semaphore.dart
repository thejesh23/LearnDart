// Semaphore — an integer-valued lock. Holds up to `permits`
// simultaneous "tokens"; anyone who wants to run must
// `.acquire()` first (which awaits if all tokens are out) and
// `.release()` when done.
//
// The canonical use: "run at most K of these async operations at
// once." Downloading 500 files but not exhausting sockets? Wrap
// each with a semaphore of permits=10. Same idea underlies
// database-connection pools, thread pools, and rate-limited API
// clients.
//
// Because Dart's event loop is single-threaded, there is no data-
// race between check and mutation — the "add to queue" and "hand
// out permit" are atomic w.r.t. each other. The queue holds
// pending Completers, each resolved as a permit is released.
//
// Mutex (concurrency/mutex.dart) is just Semaphore(1). See
// concurrency/parallel_map.dart for a common wrapper.
import 'dart:async';
import 'dart:collection';

class Semaphore {
  int _permits;
  final _waiters = Queue<Completer<void>>();

  Semaphore(int permits) : _permits = permits {
    if (permits < 1) throw ArgumentError('permits must be ≥ 1');
  }

  Future<void> acquire() {
    if (_permits > 0) {
      _permits--;
      return Future.value();
    }
    final c = Completer<void>();
    _waiters.add(c);
    return c.future;
  }

  void release() {
    if (_waiters.isNotEmpty) {
      _waiters.removeFirst().complete();
    } else {
      _permits++;
    }
  }

  /// Convenience: run [action] under the semaphore.
  Future<T> withPermit<T>(Future<T> Function() action) async {
    await acquire();
    try {
      return await action();
    } finally {
      release();
    }
  }
}

Future<void> main() async {
  final sem = Semaphore(2);
  int inFlight = 0, peak = 0;

  Future<void> task(int i) => sem.withPermit(() async {
        inFlight++;
        if (inFlight > peak) peak = inFlight;
        await Future<void>.delayed(const Duration(milliseconds: 30));
        inFlight--;
        print('task $i done');
      });

  await Future.wait([for (int i = 0; i < 6; i++) task(i)]);
  print('peak in-flight = $peak'); // 2  (the permit cap)
}
