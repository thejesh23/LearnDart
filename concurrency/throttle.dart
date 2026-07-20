// Throttle — emit at most one event per interval during a burst.
// Where debounce (concurrency/debounce.dart) collapses a burst
// into a single trailing emit, throttle guarantees a *steady
// output cadence*: the first event fires immediately, then no
// more than one every `interval` for as long as events keep
// arriving.
//
// UI examples:
//   - Scroll handlers: throttle to 60 fps so you don't recompute
//     layout 10 000 times per drag.
//   - Analytics: cap "user is moving" events to one per second.
//   - Autosave: at most once per 5 seconds while typing (contrast
//     with debounce = only when idle).
//
// Two variants matter in practice:
//   - **Leading throttle** (implemented here): emit *immediately*
//     on the first event, then swallow until the interval passes.
//     Best when responsiveness matters — the first click should
//     "feel" instant.
//   - **Trailing throttle**: emit the *last* event of the past
//     interval, at interval boundaries. Better when you want to
//     see the final state (e.g. final scroll position).
import 'dart:async';

Stream<T> throttle<T>(Stream<T> source, Duration interval) {
  late StreamController<T> out;
  DateTime lastEmit = DateTime.fromMillisecondsSinceEpoch(0);
  StreamSubscription<T>? sub;

  out = StreamController<T>(
    onListen: () {
      sub = source.listen(
        (event) {
          final now = DateTime.now();
          if (now.difference(lastEmit) >= interval) {
            lastEmit = now;
            out.add(event);
          }
          // else: drop.
        },
        onError: out.addError,
        onDone: out.close,
      );
    },
    onCancel: () => sub?.cancel(),
  );
  return out.stream;
}

Future<void> main() async {
  final ctl = StreamController<int>();
  final throttled = throttle(ctl.stream, const Duration(milliseconds: 40));
  throttled.listen((e) => print('emit: $e'));

  for (int i = 0; i < 10; i++) {
    ctl.add(i);
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }
  await ctl.close();
  // ~10 events, one per 10 ms; throttled to one per 40 ms → prints
  // roughly 0, 4 (or 5), 8 — the first of each 40 ms window.
}
