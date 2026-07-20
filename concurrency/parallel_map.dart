// `Future.wait` runs *all* futures at once. That's disastrous when
// the "unit of work" is a network fetch and the list has 10 000
// items — you'll open 10 000 sockets and get promptly rate-
// limited or crashed.
//
// `parallelMap` — bounded-concurrency variant: run at most
// `concurrency` items in flight at a time, and preserve output
// order to match the input order. Same idea as p-map (JavaScript),
// asyncio.Semaphore + gather (Python), or gopool (Go).
//
// The implementation is a walking counter over `items`, each
// worker peeling the next index and awaiting the mapper. When the
// counter is exhausted, workers return. Preserving order is done
// by writing results into a pre-sized `List<R?>` at the right
// index rather than appending as they complete.
//
// See concurrency/semaphore.dart for the primitive this replaces
// when you also need to interleave with other rate-controlled
// operations, and concurrency/future_pool.dart for a reusable
// long-lived pool.
Future<List<R>> parallelMap<T, R>(
    Iterable<T> items,
    Future<R> Function(T) mapper,
    {int concurrency = 8}) async {
  if (concurrency < 1) throw ArgumentError('concurrency must be ≥ 1');
  final list = items.toList(growable: false);
  final results = List<R?>.filled(list.length, null);
  int next = 0;

  Future<void> worker() async {
    while (true) {
      final i = next++;
      if (i >= list.length) return;
      results[i] = await mapper(list[i]);
    }
  }

  await Future.wait([for (int i = 0; i < concurrency; i++) worker()]);
  return results.cast<R>();
}

Future<void> main() async {
  final sw = Stopwatch()..start();
  final squares = await parallelMap<int, int>(
    List.generate(20, (i) => i),
    (i) async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
      return i * i;
    },
    concurrency: 5,
  );
  sw.stop();
  print(squares);
  // 20 items × 50 ms each ÷ concurrency 5 ≈ 200 ms wall clock,
  // versus 1000 ms serial or 50 ms with unbounded (but 20 sockets).
  print('elapsed ≈ ${sw.elapsedMilliseconds} ms');
}
