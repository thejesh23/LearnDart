// Async mutex — a lock that lets exactly one holder into a
// critical section at a time, with FIFO fairness for waiters.
// Formally it's Semaphore(1); factoring it out gives a nicer API
// and makes intent explicit at call sites.
//
// Why do you need a lock in single-threaded Dart? Because between
// two `await` points, another microtask can run on the event loop
// and mutate your shared state. Any read-modify-write across an
// `await` needs protection, or you'll get lost updates. Example:
//
//   int balance = 100;
//   Future<void> withdraw(int n) async {
//     final b = balance;                    // <- read
//     await Future.delayed(Duration(...));  // <- yield! anyone
//                                            //    else could run
//     balance = b - n;                       // <- write
//   }
//   // Two concurrent withdraw(50) calls can leave balance == 50
//   // instead of 0 — the classic double-spend.
//
// Wrap the critical section in `mutex.protect(() async { ... })`
// and the invariant is restored.
//
// See concurrency/semaphore.dart for the underlying primitive.
import 'dart:async';
import 'dart:collection';

class Mutex {
  bool _locked = false;
  final _waiters = Queue<Completer<void>>();

  Future<void> acquire() {
    if (!_locked) {
      _locked = true;
      return Future.value();
    }
    final c = Completer<void>();
    _waiters.add(c);
    return c.future;
  }

  void release() {
    if (_waiters.isNotEmpty) {
      _waiters.removeFirst().complete();
    } else {
      _locked = false;
    }
  }

  Future<T> protect<T>(Future<T> Function() action) async {
    await acquire();
    try {
      return await action();
    } finally {
      release();
    }
  }
}

// A tiny bank account demonstrating the race and its fix.
class Account {
  int balance;
  final _mutex = Mutex();
  Account(this.balance);

  Future<bool> withdraw(int amount) => _mutex.protect(() async {
        if (balance < amount) return false;
        final newBalance = balance - amount;
        await Future<void>.delayed(const Duration(milliseconds: 10));
        balance = newBalance;
        return true;
      });
}

Future<void> main() async {
  final a = Account(100);
  final results = await Future.wait([a.withdraw(60), a.withdraw(60)]);
  print(results);         // [true, false]  (locked; second sees balance=40)
  print(a.balance);       // 40
}
