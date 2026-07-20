// Event bus — a typed publish-subscribe channel. Anyone can
// publish events; anyone can subscribe to a specific event *type*
// and receive only those. Loosely couples producers from
// consumers — the publisher doesn't need to know who listens,
// listeners don't care where the event came from.
//
// This is the pattern behind Flutter's inherited events, Redux/BLoC
// message dispatchers, browser DOM events, and every "notification
// centre" in every desktop toolkit. Overuse is a smell — it turns
// call graphs into scavenger hunts — but for genuinely broadcast-
// shaped concerns (auth-state changed, network came back up,
// theme toggled) it's exactly right.
//
// The trick with types: `on<T>()` returns `Stream<T>` filtered
// through Dart's runtime type test. Under the hood we hold a
// single broadcast controller of `Object` and filter per
// subscriber.
import 'dart:async';

class EventBus {
  final _controller = StreamController<Object>.broadcast();

  Stream<T> on<T>() => _controller.stream.where((e) => e is T).cast<T>();

  void fire(Object event) => _controller.add(event);

  Future<void> close() => _controller.close();
}

// Typed events — plain classes; Dart's `where` picks them out.
class UserLoggedIn {
  final String username;
  const UserLoggedIn(this.username);
}

class NetworkDown {
  final String reason;
  const NetworkDown(this.reason);
}

Future<void> main() async {
  final bus = EventBus();

  bus.on<UserLoggedIn>().listen((e) => print('👤 ${e.username} signed in'));
  bus.on<NetworkDown>().listen((e) => print('🌐 offline: ${e.reason}'));

  bus.fire(const UserLoggedIn('thejesh'));
  bus.fire(const NetworkDown('DNS failure'));
  bus.fire(const UserLoggedIn('alice'));

  await Future<void>.delayed(const Duration(milliseconds: 10));
  await bus.close();
}
