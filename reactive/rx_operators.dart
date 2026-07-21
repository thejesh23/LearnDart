// Rx Operators — map, filter, take, skip, merge, zip.
// Operators are the power of reactive programming: each transforms an
// Observable into another Observable without changing the push-based
// contract.  The subscriber still calls listen() on the outermost
// Observable; the operator chain processes items lazily as they arrive.
//
// map<R>(fn):   transform each item T → R.  Like Iterable.map but push.
// filter(pred): drop items where pred returns false.  (a.k.a. where)
// take(n):      emit at most n items, then complete and cancel upstream.
// skip(n):      silently discard the first n items, then forward rest.
// merge(other): subscribe to both Observables; forward items from
//               whichever fires first; complete when BOTH complete.
// zip(other,fn):pair up items by index: (a[0],b[0]), (a[1],b[1])…;
//               complete when either source completes.
//
// All operators here are extension methods on Observable<T>, so they
// chain naturally:  observable.map(f).filter(g).take(5)
//
// These are the "tier 1" operators.  The higher-order operators
// (flatMap, switchMap, concatMap) are in reactive/switchmap.dart.
//
// Complexity: each operator adds O(1) overhead per item; the pipeline
// processes n items total in O(n) time.
//
// Relation to reactive/observable.dart: imports the Observable class
// and Subscription defined there.
//
// Run:  dart run reactive/rx_operators.dart
import 'dart:async';
import 'observable.dart';

// --- operator extensions -----------------------------------------------

extension RxOperators<T> on Observable<T> {

  /// Transform each item with [fn].
  Observable<R> map<R>(R Function(T) fn) => Observable.create((obs, sub) {
        final up = listen(
          (v) { if (!sub.isCancelled) obs.onNext(fn(v)); },
          onError: (e) { if (!sub.isCancelled) obs.onError(e); },
          onComplete: () { if (!sub.isCancelled) obs.onComplete(); },
        );
        sub.setOnCancel(up.cancel);
      });

  /// Only forward items for which [pred] returns true.
  Observable<T> filter(bool Function(T) pred) => Observable.create((obs, sub) {
        final up = listen(
          (v) { if (!sub.isCancelled && pred(v)) obs.onNext(v); },
          onError: (e) { if (!sub.isCancelled) obs.onError(e); },
          onComplete: () { if (!sub.isCancelled) obs.onComplete(); },
        );
        sub.setOnCancel(up.cancel);
      });

  /// Emit at most [n] items then complete (and cancel upstream).
  Observable<T> take(int n) => Observable.create((obs, sub) {
        int count = 0;
        late Subscription up;
        up = listen(
          (v) {
            if (sub.isCancelled) return;
            obs.onNext(v);
            count++;
            if (count >= n) { obs.onComplete(); sub.cancel(); up.cancel(); }
          },
          onError: (e) { if (!sub.isCancelled) obs.onError(e); },
          onComplete: () { if (!sub.isCancelled) obs.onComplete(); },
        );
        sub.setOnCancel(up.cancel);
      });

  /// Skip the first [n] items; forward the rest.
  Observable<T> skip(int n) => Observable.create((obs, sub) {
        int count = 0;
        final up = listen(
          (v) {
            if (sub.isCancelled) return;
            if (count++ >= n) obs.onNext(v);
          },
          onError: (e) { if (!sub.isCancelled) obs.onError(e); },
          onComplete: () { if (!sub.isCancelled) obs.onComplete(); },
        );
        sub.setOnCancel(up.cancel);
      });

  /// Interleave emissions from this and [other]; complete when both complete.
  Observable<T> merge(Observable<T> other) => Observable.create((obs, sub) {
        int doneCount = 0;
        void checkDone() {
          if (++doneCount == 2 && !sub.isCancelled) obs.onComplete();
        }

        final up1 = listen(
          (v) { if (!sub.isCancelled) obs.onNext(v); },
          onError: (e) { if (!sub.isCancelled) obs.onError(e); },
          onComplete: checkDone,
        );
        final up2 = other.listen(
          (v) { if (!sub.isCancelled) obs.onNext(v); },
          onError: (e) { if (!sub.isCancelled) obs.onError(e); },
          onComplete: checkDone,
        );
        sub.setOnCancel(() { up1.cancel(); up2.cancel(); });
      });

  /// Pair items by index with [other]; complete when either completes.
  Observable<R> zip<B, R>(Observable<B> other, R Function(T, B) fn) =>
      Observable.create((obs, sub) {
        final bufA = <T>[];
        final bufB = <B>[];
        bool doneA = false, doneB = false;

        void tryEmit() {
          while (bufA.isNotEmpty && bufB.isNotEmpty && !sub.isCancelled) {
            obs.onNext(fn(bufA.removeAt(0), bufB.removeAt(0)));
          }
          if ((doneA || doneB) && !sub.isCancelled) obs.onComplete();
        }

        final up1 = listen(
          (v) { bufA.add(v); tryEmit(); },
          onError: (e) { if (!sub.isCancelled) obs.onError(e); },
          onComplete: () { doneA = true; tryEmit(); },
        );
        final up2 = other.listen(
          (v) { bufB.add(v); tryEmit(); },
          onError: (e) { if (!sub.isCancelled) obs.onError(e); },
          onComplete: () { doneB = true; tryEmit(); },
        );
        sub.setOnCancel(() { up1.cancel(); up2.cancel(); });
      });
}

// --- demo --------------------------------------------------------------

Future<void> main() async {
  print('=== Rx Operators: map, filter, take, skip, merge, zip ===\n');

  // --- map and filter ---
  print('map and filter:');
  Observable.of([1, 2, 3, 4, 5, 6])
    .filter((x) => x % 2 == 0)
    .map((x) => x * x)
    .listen((v) => print('  $v'), onComplete: () => print('  done\n'));

  // --- take and skip ---
  print('take(3) on [1..10]:');
  Observable.of(List.generate(10, (i) => i + 1))
    .take(3)
    .listen((v) => print('  $v'), onComplete: () => print('  done'));

  print('skip(3) on [1..6]:');
  Observable.of(List.generate(6, (i) => i + 1))
    .skip(3)
    .listen((v) => print('  $v'), onComplete: () => print('  done\n'));

  // --- zip ---
  print('zip([a,b,c], [1,2,3]) → pairs:');
  Observable.of(['a', 'b', 'c'])
    .zip<int, String>(Observable.of([1, 2, 3]), (a, b) => '$a$b')
    .listen((v) => print('  $v'), onComplete: () => print('  done\n'));

  // --- merge of two interval streams (async) ---
  print('merge of two intervals (100ms and 150ms) for 400ms:');
  final fast = Observable.interval(const Duration(milliseconds: 100))
      .map((v) => 'fast:$v').take(4);
  final slow = Observable.interval(const Duration(milliseconds: 150))
      .map((v) => 'slow:$v').take(3);

  final done = Completer<void>();
  fast.merge(slow).listen(
    (v) => print('  $v'),
    onComplete: () { print('  merged done'); done.complete(); },
  );
  await done.future;

  // --- interval.map chain ---
  print('\ninterval(50ms).take(5).map(x => x*x):');
  final squares = Completer<void>();
  Observable.interval(const Duration(milliseconds: 50))
    .take(5)
    .map((x) => x * x)
    .listen(
      (v) => print('  $v'),
      onComplete: () { print('  done'); squares.complete(); },
    );
  await squares.future;
}
