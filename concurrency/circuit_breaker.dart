// Circuit breaker — the resiliency pattern for calls to a flaky
// downstream. When failures pile up, "trip" the breaker: fast-
// fail every subsequent call for a while instead of piling on
// requests that will only fail themselves. Popularised by Michael
// Nygard's *Release It!* and by Netflix's Hystrix library.
//
// Three states:
//   - **Closed**   — normal operation, requests pass through. A
//                    running failure count is kept; on reaching
//                    `failureThreshold`, transition to Open.
//   - **Open**     — requests fail immediately (no call is made).
//                    After `openDuration`, transition to Half-Open.
//   - **Half-Open** — allow *one* trial request through. If it
//                    succeeds → Closed (reset counter). If it
//                    fails → Open (restart the cooldown timer).
//
// Why does this help? The failing downstream needs a chance to
// recover. Fast-failing at the caller side also gives *your*
// service some breathing room — you don't burn threads waiting
// on doomed requests.
enum CircuitState { closed, open, halfOpen }

class OpenCircuitException implements Exception {
  const OpenCircuitException();
  @override
  String toString() => 'OpenCircuitException: circuit is open';
}

class CircuitBreaker {
  final int failureThreshold;
  final Duration openDuration;
  CircuitState _state = CircuitState.closed;
  int _failures = 0;
  DateTime? _openedAt;

  CircuitBreaker({this.failureThreshold = 5,
                  this.openDuration = const Duration(seconds: 30)});

  CircuitState get state {
    if (_state == CircuitState.open &&
        _openedAt != null &&
        DateTime.now().difference(_openedAt!) >= openDuration) {
      _state = CircuitState.halfOpen;
    }
    return _state;
  }

  Future<T> call<T>(Future<T> Function() action) async {
    final current = state;
    if (current == CircuitState.open) throw const OpenCircuitException();
    try {
      final result = await action();
      _failures = 0;
      _state = CircuitState.closed;
      return result;
    } catch (_) {
      _failures++;
      if (current == CircuitState.halfOpen || _failures >= failureThreshold) {
        _state = CircuitState.open;
        _openedAt = DateTime.now();
      }
      rethrow;
    }
  }
}

Future<void> main() async {
  final cb = CircuitBreaker(
      failureThreshold: 2, openDuration: const Duration(milliseconds: 50));
  Future<int> flaky() async => throw StateError('boom');

  for (int i = 0; i < 4; i++) {
    try {
      await cb.call(flaky);
    } catch (e) {
      print('call $i → $e   state=${cb.state}');
    }
  }
  // Two real failures, then OpenCircuitException fast-fails.
}
