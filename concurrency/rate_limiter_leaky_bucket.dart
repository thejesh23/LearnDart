// Leaky-bucket rate limiter — the algorithm's other classical
// half. Requests arrive; they queue up in a bucket of fixed
// capacity; the bucket "leaks" at a steady output rate. If a
// request arrives when the bucket is full, it's dropped or
// rejected.
//
// Contrast with the token-bucket variant
// (concurrency/rate_limiter_token_bucket.dart):
//   - Token bucket enforces a *long-term average* while allowing
//     bursts up to `capacity`.
//   - Leaky bucket enforces a *strict output rate* — no bursts
//     leave the bucket, ever.
//
// Where leaky bucket shines: shaping outbound network traffic,
// pacing writes to a database, and any downstream that literally
// cannot handle bursts (a printer, a serial port, a legacy
// system with a 2-req/sec cap).
//
// Implementation choices:
//   - We model the bucket as a queue of pending Completers.
//   - A periodic timer "leaks" one request per interval, resolving
//     the completer at the head of the queue.
import 'dart:async';
import 'dart:collection';

class LeakyBucket {
  final int capacity;
  final Duration interval;
  final Queue<Completer<void>> _queue = Queue();
  Timer? _timer;

  LeakyBucket({required this.capacity, required this.interval});

  Future<void> acquire() {
    if (_queue.length >= capacity) {
      return Future.error(StateError('bucket full'));
    }
    final c = Completer<void>();
    _queue.add(c);
    _timer ??= Timer.periodic(interval, (_) {
      if (_queue.isEmpty) {
        _timer?.cancel();
        _timer = null;
        return;
      }
      _queue.removeFirst().complete();
    });
    return c.future;
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
    while (_queue.isNotEmpty) {
      _queue.removeFirst().completeError(StateError('bucket disposed'));
    }
  }
}

Future<void> main() async {
  final bucket = LeakyBucket(
      capacity: 10, interval: const Duration(milliseconds: 50));
  final sw = Stopwatch()..start();
  final work = <Future<void>>[];
  for (int i = 0; i < 5; i++) {
    work.add(bucket.acquire().then((_) => print('req $i at ${sw.elapsedMilliseconds} ms')));
  }
  await Future.wait(work);
  bucket.dispose();
  // Prints spaced ~50 ms apart, regardless of arrival burst.
}
