// Observable — the foundation of reactive programming (ReactiveX pattern).
// Reactive programming is a paradigm for working with asynchronous push-
// based data streams.  At its core sits the Observable contract:
//
//   A producer pushes items to consumers (Observers) via:
//     • onNext(T)   — a new item arrived.
//     • onError(e)  — a terminal error; no more items.
//     • onComplete()— the stream ended normally; no more items.
//   Only one terminal event (error OR complete) may fire per subscription.
//
// Observable vs Dart's Stream:
//   • Stream is "hot" by default and difficult to make cold.  Each call
//     to stream.listen() doesn't re-run the source logic.
//   • Observable here is "cold": subscribing re-runs the producer.  If
//     you subscribe twice to Observable.of([1,2,3]), you get the values
//     twice — independently.  This mirrors RxJS / RxDart cold observables.
//   • Operators (see rx_operators.dart) are composable and return new
//     Observables, forming a lazy pipeline.
//
// Factory constructors:
//   of(list)          — emits items from a list, then completes.
//   fromStream(stream)— wraps a Dart Stream (bridge to existing APIs).
//   interval(d)       — emits 0, 1, 2, … every duration d (async).
//   create(fn)        — custom producer; the fundamental building block.
//
// Subscription: returned by subscribe(); call cancel() to unsubscribe.
//
// Relation to reactive/rx_operators.dart (operators) and
// reactive/switchmap.dart (higher-order operators).
//
// Run:  dart run reactive/observable.dart
import 'dart:async';

// --- Observer ----------------------------------------------------------

abstract class Observer<T> {
  void onNext(T value);
  void onError(Object error);
  void onComplete();
}

class _FnObserver<T> implements Observer<T> {
  final void Function(T) _next;
  final void Function(Object)? _error;
  final void Function()? _complete;
  _FnObserver(this._next, [this._error, this._complete]);
  @override void onNext(T v) => _next(v);
  @override void onError(Object e) => (_error ?? (_) {})(e);
  @override void onComplete() => (_complete ?? () {})();
}

// --- Subscription ------------------------------------------------------

class Subscription {
  bool _cancelled = false;
  void Function()? _onCancel;

  Subscription();

  void setOnCancel(void Function() fn) => _onCancel = fn;
  bool get isCancelled => _cancelled;

  void cancel() {
    if (!_cancelled) {
      _cancelled = true;
      _onCancel?.call();
    }
  }
}

// --- Observable --------------------------------------------------------

class Observable<T> {
  final void Function(Observer<T> observer, Subscription sub) _producer;

  Observable._(this._producer);

  /// Subscribe and return a [Subscription] to cancel early.
  Subscription subscribe(Observer<T> observer) {
    final sub = Subscription();
    _producer(observer, sub);
    return sub;
  }

  /// Convenience wrapper: subscribe with plain functions.
  Subscription listen(
    void Function(T) onNext, {
    void Function(Object)? onError,
    void Function()? onComplete,
  }) =>
      subscribe(_FnObserver(onNext, onError, onComplete));

  // --- factory constructors -------------------------------------------

  /// Synchronously emits each item in [items], then completes.
  factory Observable.of(List<T> items) => Observable._(
        (obs, sub) {
          for (final item in items) {
            if (sub.isCancelled) return;
            obs.onNext(item);
          }
          if (!sub.isCancelled) obs.onComplete();
        },
      );

  /// Emits incrementing integers (as T=int) once every [period].
  static Observable<int> interval(Duration period) => Observable._(
        (obs, sub) {
          int count = 0;
          final timer = Timer.periodic(period, (_) {
            if (sub.isCancelled) return;
            obs.onNext(count++);
          });
          sub.setOnCancel(timer.cancel);
        },
      );

  /// Full custom producer for arbitrary push logic.
  factory Observable.create(
          void Function(Observer<T> obs, Subscription sub) producer) =>
      Observable._(producer);
}

// --- demo --------------------------------------------------------------

Future<void> main() async {
  print('=== Observable — Cold Push-Based Streams ===\n');

  // 1. of([1,2,3]) — cold: each subscriber gets independent emissions.
  final nums = Observable.of([1, 2, 3]);

  print('Subscriber A:');
  nums.listen((v) => print('  A got $v'), onComplete: () => print('  A done'));

  print('Subscriber B (independent run of the same observable):');
  nums.listen((v) => print('  B got $v'), onComplete: () => print('  B done'));

  // 2. Cancelling early.
  print('\nCancellation demo:');
  final all = Observable.of([10, 20, 30, 40, 50]);
  int seen = 0;
  late Subscription sub;
  sub = all.listen((v) {
    print('  got $v');
    seen++;
    if (seen == 2) {
      sub.cancel();
      print('  cancelled after 2 items');
    }
  }, onComplete: () => print('  completed (should not print)'));

  // 3. interval — async timer-based observable.
  print('\ninterval(100ms) for 5 ticks:');
  final completer = Completer<void>();
  int tick = 0;
  late Subscription intSub;
  intSub = Observable.interval(const Duration(milliseconds: 100)).listen(
    (v) {
      print('  tick $v');
      tick++;
      if (tick == 5) {
        intSub.cancel();
        completer.complete();
      }
    },
  );
  await completer.future;
  print('Done.');
}
