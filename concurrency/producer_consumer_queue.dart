// Bounded producer–consumer queue with backpressure. A producer
// calls `put(item)`; if the queue is full, `put` awaits until a
// consumer removes something. A consumer calls `take()`; if the
// queue is empty, `take` awaits until a producer inserts.
//
// The "bounded" part is the key. An *unbounded* queue lets a fast
// producer OOM the process before the slow consumer can catch up.
// A bounded queue provides backpressure — the producer's own
// speed is limited by the consumer's throughput, no monitoring,
// no dropping, no crash.
//
// This is the exact primitive behind Java's ArrayBlockingQueue,
// Kotlin's Channel(capacity = N), Go's `make(chan T, N)`, and
// most implementations of "stage" in a pipeline. Under the hood
// it's a fixed-size buffer plus two Completer queues — one for
// waiting producers, one for waiting consumers.
import 'dart:async';
import 'dart:collection';

class BoundedQueue<T> {
  final int capacity;
  final Queue<T> _buffer = Queue<T>();
  final Queue<Completer<void>> _putWaiters = Queue();
  final Queue<Completer<T>> _takeWaiters = Queue();

  BoundedQueue(this.capacity) {
    if (capacity < 1) throw ArgumentError('capacity must be ≥ 1');
  }

  int get length => _buffer.length;
  bool get isEmpty => _buffer.isEmpty;
  bool get isFull => _buffer.length >= capacity;

  Future<void> put(T item) async {
    // A blocked consumer? Hand the item off directly and skip the buffer.
    if (_takeWaiters.isNotEmpty) {
      _takeWaiters.removeFirst().complete(item);
      return;
    }
    if (_buffer.length < capacity) {
      _buffer.add(item);
      return;
    }
    final c = Completer<void>();
    _putWaiters.add(c);
    await c.future;
    _buffer.add(item);
  }

  Future<T> take() async {
    if (_buffer.isNotEmpty) {
      final v = _buffer.removeFirst();
      if (_putWaiters.isNotEmpty) _putWaiters.removeFirst().complete();
      return v;
    }
    final c = Completer<T>();
    _takeWaiters.add(c);
    return c.future;
  }
}

Future<void> main() async {
  final q = BoundedQueue<int>(3);

  Future<void> producer() async {
    for (int i = 0; i < 8; i++) {
      await q.put(i);
      print('put $i (queue len ${q.length})');
    }
  }

  Future<void> consumer() async {
    for (int i = 0; i < 8; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 20));
      final v = await q.take();
      print('got $v');
    }
  }

  await Future.wait([producer(), consumer()]);
}
