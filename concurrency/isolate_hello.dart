// Isolates — Dart's answer to "true" parallelism. An `Isolate`
// is a separate execution context with its own heap, its own
// event loop, and *no shared mutable memory* with anyone else.
// Communication is exclusively by message-passing over ports.
//
// Because heaps aren't shared, isolates are immune to data races
// by construction — you can't accidentally corrupt state across
// isolate boundaries because there's no shared state to corrupt.
// The trade-off: message passing has serialisation cost; not
// everything can be sent (unsent-able objects include most
// closures capturing arbitrary state, native handles, and stream
// controllers).
//
// Use isolates when CPU-bound work would block your main event
// loop (image decoding, JSON parsing megabytes, cryptography,
// simulation). *Don't* use them for I/O — `Future` on the main
// isolate already handles I/O concurrently. Rule of thumb: if it
// would take > 16 ms and hurts your 60 fps, offload it.
//
// Two APIs to know:
//   - `Isolate.run(fn)` — one-shot: spawn, run, return, tear down.
//     The modern default (Dart 2.19+); use it whenever you don't
//     need to reuse the isolate.
//   - `Isolate.spawn(entry, arg)` — long-lived: you get an
//     Isolate handle and set up `ReceivePort`/`SendPort` yourself.
//     Use for pools (see concurrency/isolate_worker_pool.dart) or
//     any worker that receives many messages over time.
//
// The entry function for `spawn` must be a top-level or static
// function; closures capturing local state don't cross the
// isolate boundary.
import 'dart:async';
import 'dart:isolate';

/// CPU-bound work: sum of squares up to n. Runs in another isolate,
/// so the main isolate's event loop stays responsive.
int _sumOfSquares(int n) {
  int total = 0;
  for (int i = 1; i <= n; i++) total += i * i;
  return total;
}

/// Long-lived worker entrypoint. Receives an int, replies with its
/// square, terminates on 'exit'.
void _squarer(SendPort mainPort) {
  final inbox = ReceivePort();
  mainPort.send(inbox.sendPort);
  inbox.listen((message) {
    if (message == 'exit') { inbox.close(); return; }
    if (message is (int, SendPort)) {
      final (n, replyTo) = message;
      replyTo.send(n * n);
    }
  });
}

Future<void> main() async {
  // 1. One-shot: `Isolate.run` — the modern, easy case.
  final result = await Isolate.run(() => _sumOfSquares(1000000));
  print('sum of squares up to 1e6 = $result');

  // 2. Long-lived: `Isolate.spawn` — set up two-way ports ourselves.
  final fromWorker = ReceivePort();
  await Isolate.spawn(_squarer, fromWorker.sendPort);

  final events = StreamQueue(fromWorker);
  final workerPort = await events.next as SendPort;

  Future<int> square(int n) async {
    final reply = ReceivePort();
    workerPort.send((n, reply.sendPort));
    final answer = await reply.first as int;
    reply.close();
    return answer;
  }

  print(await square(7));   // 49
  print(await square(11));  // 121
  workerPort.send('exit');
  fromWorker.close();
}

/// A tiny StreamQueue-style helper (dart:async provides the real
/// one, but through package:async — we roll a bare-bones one here
/// so this file has no external dependencies).
class StreamQueue<T> {
  final Stream<T> _source;
  late final StreamIterator<T> _it;
  StreamQueue(this._source) { _it = StreamIterator<T>(_source); }
  Future<T> get next async {
    await _it.moveNext();
    return _it.current;
  }
}
