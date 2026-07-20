// Debounce — collapse a bursty stream of events into "the most
// recent one, after things have been quiet for `wait`". The
// classic UI use case: only fire the search-as-you-type query
// after the user has *stopped* typing for 300 ms, not after every
// keystroke.
//
// Mechanic: each new event resets a timer. If the timer fires
// before another event arrives, we emit the last event downstream.
// Any newer event cancels the pending fire and starts fresh.
//
// Debounce contrasts with **throttle** (concurrency/throttle.dart):
//   - Debounce  = fire *once* after the burst ends.
//   - Throttle  = fire at most *once per interval* during the burst.
//
// Common uses beyond search-as-you-type: auto-save after edits
// pause, resize-handler that recomputes layout only after the
// user stops dragging, form-validation on blur.
import 'dart:async';

Stream<T> debounce<T>(Stream<T> source, Duration wait) {
  late StreamController<T> out;
  Timer? timer;
  T? lastEvent;
  bool hasEvent = false;
  StreamSubscription<T>? sub;

  void emit() {
    if (hasEvent) {
      out.add(lastEvent as T);
      hasEvent = false;
    }
  }

  out = StreamController<T>(
    onListen: () {
      sub = source.listen(
        (event) {
          lastEvent = event;
          hasEvent = true;
          timer?.cancel();
          timer = Timer(wait, emit);
        },
        onError: out.addError,
        onDone: () {
          timer?.cancel();
          emit();
          out.close();
        },
      );
    },
    onCancel: () async {
      timer?.cancel();
      await sub?.cancel();
    },
  );
  return out.stream;
}

Future<void> main() async {
  final ctl = StreamController<String>();
  final debounced = debounce(ctl.stream, const Duration(milliseconds: 40));
  debounced.listen((e) => print('emit: $e'));

  ctl.add('a');
  await Future<void>.delayed(const Duration(milliseconds: 10));
  ctl.add('ab');
  await Future<void>.delayed(const Duration(milliseconds: 10));
  ctl.add('abc');                    // burst — only this survives
  await Future<void>.delayed(const Duration(milliseconds: 100));
  ctl.add('later');                  // separate burst
  await ctl.close();
  await Future<void>.delayed(const Duration(milliseconds: 100));
  // Expected: emit: abc,  emit: later
}
