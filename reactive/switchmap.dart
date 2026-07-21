// SwitchMap, FlatMap, ConcatMap — higher-order observable operators.
// "Higher-order" means the mapper function returns an Observable itself,
// not just a plain value.  These operators differ only in HOW they
// handle multiple concurrent inner observables:
//
//   flatMap(fn)  — subscribes to every inner observable immediately,
//                  merging all their emissions as they arrive.
//                  Use: parallel independent async operations.
//
//   switchMap(fn)— on each new outer item, CANCEL the previous inner
//                  observable and subscribe to the new one.
//                  Use: search-as-you-type — discard stale results.
//                  This is the "cancel stale requests" operator and the
//                  source of most RxJS confusion in UI code.
//
//   concatMap(fn)— queue inner observables; subscribe to the next only
//                  after the current one completes.  Preserves order.
//                  Use: sequential async side-effects (uploading files).
//
// Visual:  outer emits A, B, C (each maps to a delayed inner stream)
//
//   flatMap:    A──1──2──3
//               B──1──2──3    → merged: 1A,1B,2A,1C,2B,3A,2C,3B,3C ...
//               C──1──2──3
//
//   switchMap:  A──1──(cancelled when B arrives)
//                  B──1──(cancelled when C arrives)
//                     C──1──2──3      → only C's items arrive
//
//   concatMap:  A─1─2─3─|B─1─2─3─|C─1─2─3─|  (queued in order)
//
// Complexity: each operator processes n outer × m inner items in O(nm).
//
// Relation to rx_operators.dart: switchMap, flatMap, concatMap are the
// "higher-order" equivalents of merge, and build on the same Subscription
// cancellation mechanism defined in observable.dart.
//
// Run:  dart run reactive/switchmap.dart
import 'dart:async';
import 'observable.dart';
import 'rx_operators.dart';

// --- higher-order operators as extension methods -----------------------

extension RxHigherOrder<T> on Observable<T> {

  /// Subscribe to each inner observable concurrently; merge outputs.
  Observable<R> flatMap<R>(Observable<R> Function(T) fn) =>
      Observable.create((obs, sub) {
        int activeInner = 0;
        bool outerDone = false;

        void checkComplete() {
          if (outerDone && activeInner == 0 && !sub.isCancelled) {
            obs.onComplete();
          }
        }

        final outerSub = listen(
          (v) {
            if (sub.isCancelled) return;
            activeInner++;
            fn(v).listen(
              (inner) { if (!sub.isCancelled) obs.onNext(inner); },
              onError: (e) { if (!sub.isCancelled) obs.onError(e); },
              onComplete: () { activeInner--; checkComplete(); },
            );
          },
          onError: (e) { if (!sub.isCancelled) obs.onError(e); },
          onComplete: () { outerDone = true; checkComplete(); },
        );
        sub.setOnCancel(outerSub.cancel);
      });

  /// Cancel the previous inner observable on each new outer emission.
  Observable<R> switchMap<R>(Observable<R> Function(T) fn) =>
      Observable.create((obs, sub) {
        Subscription? innerSub;

        final outerSub = listen(
          (v) {
            if (sub.isCancelled) return;
            // Cancel any in-flight inner subscription.
            innerSub?.cancel();
            innerSub = fn(v).listen(
              (inner) { if (!sub.isCancelled) obs.onNext(inner); },
              onError: (e) { if (!sub.isCancelled) obs.onError(e); },
              onComplete: () { if (!sub.isCancelled) obs.onComplete(); },
            );
          },
          onError: (e) { if (!sub.isCancelled) obs.onError(e); },
          onComplete: () {/* outer done; let inner finish */},
        );
        sub.setOnCancel(() { outerSub.cancel(); innerSub?.cancel(); });
      });

  /// Queue inner observables; subscribe to next only when current completes.
  Observable<R> concatMap<R>(Observable<R> Function(T) fn) =>
      Observable.create((obs, sub) {
        final queue = <T>[];
        bool processing = false;
        bool outerDone = false;

        void processNext() {
          if (sub.isCancelled || queue.isEmpty) {
            if (outerDone && queue.isEmpty && !sub.isCancelled) obs.onComplete();
            return;
          }
          processing = true;
          final item = queue.removeAt(0);
          fn(item).listen(
            (inner) { if (!sub.isCancelled) obs.onNext(inner); },
            onError: (e) { if (!sub.isCancelled) obs.onError(e); },
            onComplete: () { processing = false; processNext(); },
          );
        }

        final outerSub = listen(
          (v) {
            if (sub.isCancelled) return;
            queue.add(v);
            if (!processing) processNext();
          },
          onError: (e) { if (!sub.isCancelled) obs.onError(e); },
          onComplete: () {
            outerDone = true;
            if (!processing && queue.isEmpty && !sub.isCancelled) {
              obs.onComplete();
            }
          },
        );
        sub.setOnCancel(outerSub.cancel);
      });
}

// --- helpers -----------------------------------------------------------

/// Simulate an async "search fetch": emits one result after [delay].
Observable<String> _fakeSearch(String query, Duration delay) =>
    Observable.create((obs, sub) {
      final timer = Timer(delay, () {
        if (!sub.isCancelled) {
          obs.onNext('result for "$query"');
          obs.onComplete();
        }
      });
      sub.setOnCancel(timer.cancel);
    });

/// Observable that emits [values] at [interval] spacing.
Observable<T> _timedOf<T>(List<T> values, Duration interval) =>
    Observable.create((obs, sub) {
      int i = 0;
      final timer = Timer.periodic(interval, (_) {
        if (sub.isCancelled) return;
        if (i < values.length) {
          obs.onNext(values[i++]);
        } else {
          obs.onComplete();
          sub.cancel();
        }
      });
      sub.setOnCancel(timer.cancel);
    });

// --- demo --------------------------------------------------------------

Future<void> main() async {
  print('=== SwitchMap / FlatMap / ConcatMap ===\n');

  // Simulate search queries arriving every 80ms.
  // Each "fetch" takes 150ms — longer than the query interval.
  // With switchMap, only the LAST query's result arrives.
  final queries = ['d', 'da', 'dar', 'dart'];

  // --- switchMap: stale results are cancelled ---
  print('--- switchMap (search-as-you-type) ---');
  print('Queries: $queries (80ms apart, fetch takes 150ms each)');
  final swDone = Completer<void>();
  _timedOf(queries, const Duration(milliseconds: 80))
    .switchMap((q) => _fakeSearch(q, const Duration(milliseconds: 150)))
    .listen(
      (v) => print('  switchMap got: $v'),
      onComplete: () { print('  (only last query won)\n'); swDone.complete(); },
    );
  await swDone.future;

  // --- flatMap: all results arrive (possibly out of order) ---
  print('--- flatMap (concurrent fetches, may interleave) ---');
  final fmDone = Completer<void>();
  int fmCount = 0;
  _timedOf(queries, const Duration(milliseconds: 80))
    .flatMap((q) {
      // Vary the delay so they arrive in different order.
      final d = Duration(milliseconds: 120 - queries.indexOf(q) * 20);
      return _fakeSearch(q, d);
    })
    .listen(
      (v) { print('  flatMap got: $v'); fmCount++; },
      onComplete: () {
        print('  ($fmCount results, possibly out of order)\n');
        fmDone.complete();
      },
    );
  await fmDone.future;

  // --- concatMap: results arrive in order, each waits for previous ---
  print('--- concatMap (sequential, in-order) ---');
  final cmDone = Completer<void>();
  int cmCount = 0;
  _timedOf(queries, const Duration(milliseconds: 80))
    .concatMap((q) => _fakeSearch(q, const Duration(milliseconds: 60)))
    .listen(
      (v) { print('  concatMap got: $v'); cmCount++; },
      onComplete: () {
        print('  ($cmCount results, guaranteed in order)\n');
        cmDone.complete();
      },
    );
  await cmDone.future;

  // --- simple flatMap of synchronous observables ---
  print('--- flatMap of synchronous inner observables ---');
  Observable.of([1, 2, 3])
    .flatMap((n) => Observable.of(List.generate(n, (i) => '$n×${i+1}=${n*(i+1)}')))
    .listen(
      (v) => print('  $v'),
      onComplete: () => print('  done'),
    );
}
