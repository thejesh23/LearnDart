// Cooperative cancellation. Dart Futures aren't natively
// cancellable — once an async operation starts, there's no built-
// in "kill" switch. The idiomatic answer is a *token*: a small
// value the operation checks periodically ("has anyone asked me
// to stop?") and honours by throwing `CancelledException` at the
// next natural yield point.
//
// The token exposes two views:
//   - Producer side (`CancellationToken`): the operation reads
//     `.isCancelled` or awaits `.whenCancelled` and voluntarily
//     bails out.
//   - Consumer side (`CancellationSource`): the caller invokes
//     `.cancel()` to signal.
//
// Compare with Go's `context.Context` and .NET's
// `CancellationTokenSource` — the pattern is deliberately similar.
// This is the correct primitive for HTTP request cancellation,
// user-abortable searches, and any long-running task that should
// stop when the caller loses interest.
import 'dart:async';

class CancelledException implements Exception {
  final String message;
  const CancelledException([this.message = 'operation cancelled']);
  @override
  String toString() => 'CancelledException: $message';
}

class CancellationToken {
  final CancellationSource _source;
  CancellationToken._(this._source);
  bool get isCancelled => _source._cancelled;
  Future<void> get whenCancelled => _source._completer.future;
  void throwIfCancelled() {
    if (isCancelled) throw const CancelledException();
  }
}

class CancellationSource {
  bool _cancelled = false;
  final _completer = Completer<void>();
  late final token = CancellationToken._(this);
  void cancel() {
    if (_cancelled) return;
    _cancelled = true;
    _completer.complete();
  }
}

/// Example: count up to [n] with a 10 ms tick, bailing out early
/// if cancelled.
Future<int> countUp(int n, CancellationToken token) async {
  int count = 0;
  for (int i = 0; i < n; i++) {
    await Future<void>.delayed(const Duration(milliseconds: 10));
    token.throwIfCancelled();
    count++;
  }
  return count;
}

Future<void> main() async {
  final source = CancellationSource();
  Timer(const Duration(milliseconds: 35), source.cancel);
  try {
    final r = await countUp(100, source.token);
    print('finished: $r');
  } on CancelledException catch (e) {
    print(e);  // CancelledException: operation cancelled
  }
}
