// Exponential backoff with jitter — the retry policy of every
// well-behaved network client. When a call to a flaky service
// fails, don't hammer it with immediate retries; back off with
// exponentially-growing delays, and add jitter so a stampede of
// clients doesn't synchronise their retries into a thundering
// herd.
//
// Delay formula:
//   base * 2^attempt, clamped to `maxDelay`, then randomised in
//   [0, delay] ("full jitter" — the AWS-recommended variant).
//
// A caller supplies:
//   - A closure that performs the operation.
//   - An optional `retryable` predicate (default: retry all
//     exceptions). Retrying a 400 Bad Request is pointless — the
//     predicate lets you retry only transient errors like 503,
//     timeouts, or `SocketException`.
//   - `maxAttempts` — after this many tries, rethrow.
//
// See AWS's classic post *"Exponential backoff and jitter"*
// (Marc Brooker, 2015) for the derivation.
import 'dart:async';
import 'dart:math';

Future<T> retryWithBackoff<T>(
    Future<T> Function() action, {
    int maxAttempts = 5,
    Duration base = const Duration(milliseconds: 100),
    Duration maxDelay = const Duration(seconds: 30),
    bool Function(Object error)? retryable,
    Random? random,
}) async {
  final rng = random ?? Random();
  Object? lastError;
  for (int attempt = 0; attempt < maxAttempts; attempt++) {
    try {
      return await action();
    } catch (e) {
      lastError = e;
      if (retryable != null && !retryable(e)) rethrow;
      if (attempt == maxAttempts - 1) rethrow;
      final capMs = min(maxDelay.inMilliseconds,
                        base.inMilliseconds * (1 << attempt));
      final delayMs = rng.nextInt(capMs + 1);
      await Future<void>.delayed(Duration(milliseconds: delayMs));
    }
  }
  throw lastError!;
}

Future<void> main() async {
  int calls = 0;
  final result = await retryWithBackoff<String>(() async {
    calls++;
    if (calls < 3) throw StateError('transient');
    return 'ok';
  }, base: const Duration(milliseconds: 10));
  print('$result after $calls tries');   // ok after 3 tries
}
