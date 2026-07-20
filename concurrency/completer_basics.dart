// Completer — the bridge between callback-style APIs and Dart's
// Future world. A Completer<T> owns a Future<T> and hands out
// exactly one `.future` handle. You resolve it later by calling
// `.complete(value)` or `.completeError(err)`.
//
// The classic use: wrap an old callback API in a Future.
//   Timer(d, () => completer.complete(42)) → await completer.future;
//
// You almost never need Completer for pure Dart code — `async`
// functions and `Future.delayed` cover most cases. Reach for it
// when:
//   1. You're wrapping an event-based / callback-based API (Timer,
//      onLoad, platform channels, streams' first-event).
//   2. You need to *choose* when to resolve a future from outside
//      the function that returned it — e.g. an internal request
//      map that resolves when a matching response arrives.
//   3. You want the caller to await something that can be signalled
//      from many places (though a Stream may be a better fit).
//
// Anti-pattern: `Completer<T>` inside a function that only awaits
// something and then completes — just `return await ...` instead.
import 'dart:async';

/// Convert a callback-style API (a `Timer`) into a Future.
Future<int> waitAndReturn(int value, Duration delay) {
  final completer = Completer<int>();
  Timer(delay, () => completer.complete(value));
  return completer.future;
}

/// Fake pending-request registry. Somewhere else in the code
/// (e.g. a message handler), someone calls `resolve(id, value)`
/// and the awaiter is unblocked.
class RequestRegistry {
  final _pending = <int, Completer<String>>{};

  Future<String> awaitResponse(int id) {
    final c = Completer<String>();
    _pending[id] = c;
    return c.future;
  }

  void resolve(int id, String value) {
    _pending.remove(id)?.complete(value);
  }
}

Future<void> main() async {
  print(await waitAndReturn(42, const Duration(milliseconds: 20)));

  final reg = RequestRegistry();
  final pending = reg.awaitResponse(1);
  Timer(const Duration(milliseconds: 10), () => reg.resolve(1, 'ok'));
  print(await pending); // ok
}
