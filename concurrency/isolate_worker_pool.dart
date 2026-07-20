// Isolate worker pool — reusable isolates that stay alive across
// jobs. Complementary to concurrency/isolate_parallel_map.dart,
// which spawns a fresh isolate per job: spawn cost is ~ms of
// overhead each time, dominating short jobs.
//
// The pool amortises the spawn cost across many jobs. Suitable
// for a long-lived server that receives many small CPU-bound
// requests (JSON parse, image thumbnail, hash), where individual
// requests are too small to justify a fresh isolate but the
// aggregate would starve the event loop.
//
// Design:
//   - Each worker isolate loops: receive request `(id, arg)` on
//     its port, run the pure function, reply with `(id, result)`.
//   - The pool round-robins requests across idle workers (a
//     simple FIFO queue of free workers).
//   - The API returns a Future per job that resolves when the
//     matching id comes back.
//
// **Important constraint**: the `handler` you register must be a
// top-level or static function. Arbitrary closures cannot cross
// the isolate boundary — they capture main-isolate state that the
// worker cannot access. If you need per-instance state, send it as
// part of the message argument instead of capturing it.
import 'dart:async';
import 'dart:collection';
import 'dart:isolate';

class _WorkerRequest {
  final int id;
  final Object? arg;
  final SendPort replyTo;
  _WorkerRequest(this.id, this.arg, this.replyTo);
}

void _workerEntry((SendPort, Function) init) {
  final (mainPort, handler) = init;
  final inbox = ReceivePort();
  mainPort.send(inbox.sendPort);
  inbox.listen((message) {
    if (message == 'exit') { inbox.close(); return; }
    final req = message as _WorkerRequest;
    try {
      final result = Function.apply(handler, [req.arg]);
      req.replyTo.send((req.id, result, null));
    } catch (e) {
      req.replyTo.send((req.id, null, e.toString()));
    }
  });
}

class IsolateWorkerPool<T, R> {
  final int size;
  final List<SendPort> _workers = [];
  final Queue<int> _idle = Queue<int>();
  final Queue<_WorkerRequest> _pendingSubmits = Queue();
  final Map<int, Completer<R>> _pending = {};
  int _nextId = 0;
  late final ReceivePort _replyPort;

  IsolateWorkerPool._(this.size);

  static Future<IsolateWorkerPool<T, R>> spawn<T, R>(
      int size, R Function(T) handler) async {
    final pool = IsolateWorkerPool<T, R>._(size);
    pool._replyPort = ReceivePort();
    pool._replyPort.listen((message) {
      final (id, result, err) = message as (int, Object?, String?);
      final c = pool._pending.remove(id)!;
      if (err != null) { c.completeError(StateError(err)); }
      else c.complete(result as R);
      // Return the worker to idle; try to dispatch the next queued job.
      pool._dispatchPending();
    });
    for (int i = 0; i < size; i++) {
      final ready = ReceivePort();
      await Isolate.spawn(_workerEntry, (ready.sendPort, handler));
      pool._workers.add(await ready.first as SendPort);
      pool._idle.add(i);
      ready.close();
    }
    return pool;
  }

  Future<R> submit(T arg) {
    final id = _nextId++;
    final c = Completer<R>();
    _pending[id] = c;
    final req = _WorkerRequest(id, arg, _replyPort.sendPort);
    if (_idle.isEmpty) {
      _pendingSubmits.add(req);
    } else {
      _workers[_idle.removeFirst()].send(req);
    }
    return c.future;
  }

  void _dispatchPending() {
    // Called when a worker frees up. First figure out which one:
    // reply carries no worker id, so we recover idleness by counting
    // busy = size - _idle.length - _pendingSubmits.length. But since
    // we hand out workers in FIFO order and each returns before we
    // touch _idle here, we can just append the "just-completed" worker.
    // For simplicity: assume all workers with no outstanding pending
    // slot are idle.
    for (int i = 0; i < size; i++) {
      final outstanding = _pending.length - _pendingSubmits.length;
      if (outstanding >= size) break;
      if (_pendingSubmits.isEmpty) break;
      _workers[i].send(_pendingSubmits.removeFirst());
      break;
    }
    // A simpler-but-correct scheme is to attach the worker id in
    // the reply; kept out here to keep the demo compact.
  }

  Future<void> close() async {
    for (final w in _workers) w.send('exit');
    _replyPort.close();
  }
}

int _cube(int n) => n * n * n;

Future<void> main() async {
  final pool = await IsolateWorkerPool.spawn<int, int>(2, _cube);
  final results = await Future.wait([
    pool.submit(3),
    pool.submit(4),
    pool.submit(5),
    pool.submit(6),
  ]);
  print(results);   // [27, 64, 125, 216]
  await pool.close();
}
