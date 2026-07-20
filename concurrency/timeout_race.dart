// `Future.any` returns the first future to *complete* (either with
// a value or with an error). Two very common patterns fall out of
// it:
//
//   1. **Timeout race** — race the operation against a delayed
//      exception. If the operation is slower than the timeout,
//      the exception wins and the caller sees a timeout error.
//      Dart's `Future.timeout` does exactly this and is the
//      idiomatic form; the explicit `Future.any` version shown
//      here makes the mechanic transparent.
//
//   2. **First-successful of N attempts** — race N replicas of a
//      request against each other; use the first that succeeds
//      and ignore the rest. This is the "hedged request" pattern
//      popular in Jeff Dean's Google talks: at the p99 tail
//      latency, sending a second attempt to another replica after
//      a modest delay cuts p99 dramatically.
//
// Note: races don't cancel losers. Dart Futures aren't cancellable
// (see concurrency/cancellation_token.dart). The losing operations
// keep running until they finish; if they hold resources, you
// need to plumb a cancellation token through.
import 'dart:async';

class TimeoutException implements Exception {
  final Duration timeout;
  const TimeoutException(this.timeout);
  @override
  String toString() => 'TimeoutException: exceeded $timeout';
}

Future<T> withTimeout<T>(Future<T> op, Duration timeout) {
  final trip = Future<T>.delayed(timeout, () => throw TimeoutException(timeout));
  return Future.any([op, trip]);
}

Future<T> firstSuccessful<T>(List<Future<T> Function()> attempts) {
  final futures = attempts.map((f) => f()).toList();
  return Future.any(futures);
}

Future<void> main() async {
  // 1. Timeout wins:
  try {
    await withTimeout(
        Future<void>.delayed(const Duration(milliseconds: 50)),
        const Duration(milliseconds: 20));
    print('completed');
  } on TimeoutException catch (e) {
    print(e);
  }

  // 2. Op wins:
  final r = await withTimeout(
      Future<String>.delayed(const Duration(milliseconds: 10), () => 'fast'),
      const Duration(milliseconds: 50));
  print(r);   // fast

  // 3. Hedged: three replicas of the same request, fastest wins.
  final winner = await firstSuccessful<int>([
    () => Future.delayed(const Duration(milliseconds: 40), () => 1),
    () => Future.delayed(const Duration(milliseconds: 15), () => 2),
    () => Future.delayed(const Duration(milliseconds: 30), () => 3),
  ]);
  print('hedged winner: $winner');    // 2
}
