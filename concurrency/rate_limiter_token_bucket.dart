// Token-bucket rate limiter — the algorithm behind AWS API Gateway,
// GitHub's REST rate limits, and most modern web-service throttles.
//
// The bucket holds up to `capacity` tokens. Tokens refill at a
// steady rate of `refillRate` per second. Every call to `acquire`
// consumes one token; if none are available, the caller waits
// until the bucket refills enough.
//
// Two properties make this pattern beloved:
//   1. **Burst tolerance** — you can consume up to `capacity`
//      tokens instantly (e.g. after a quiet period), then settle
//      into the steady rate. That's much nicer than a rigid
//      "1/second" hard cap.
//   2. **No timers required** — refill is computed lazily on each
//      acquire from the elapsed time; no background job, no
//      wasted CPU when idle.
//
// Contrast with the leaky-bucket variant in
// concurrency/rate_limiter_leaky_bucket.dart, which enforces a
// hard output rate with no bursts.
import 'dart:async';

class TokenBucket {
  final double capacity;
  final double refillPerSec;
  double _tokens;
  DateTime _last;

  TokenBucket({required this.capacity, required this.refillPerSec})
      : _tokens = capacity,
        _last = DateTime.now();

  void _refill() {
    final now = DateTime.now();
    final elapsed = now.difference(_last).inMicroseconds / 1e6;
    _tokens = (_tokens + elapsed * refillPerSec).clamp(0.0, capacity);
    _last = now;
  }

  Future<void> acquire([int tokens = 1]) async {
    while (true) {
      _refill();
      if (_tokens >= tokens) {
        _tokens -= tokens;
        return;
      }
      final needed = tokens - _tokens;
      final waitMs = (needed / refillPerSec * 1000).ceil();
      await Future<void>.delayed(Duration(milliseconds: waitMs));
    }
  }
}

Future<void> main() async {
  final bucket = TokenBucket(capacity: 5, refillPerSec: 10);
  final sw = Stopwatch()..start();
  for (int i = 0; i < 10; i++) {
    await bucket.acquire();
    print('call $i at ${sw.elapsedMilliseconds} ms');
  }
  // First 5 near-instant (burst); remaining 5 spaced ~100 ms apart.
}
