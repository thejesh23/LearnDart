// Least-Recently-Used cache: capacity-bounded map that evicts the least
// recently touched key on overflow. Backed by LinkedHashMap for O(1) ops.
import 'dart:collection';

class LRUCache<K, V> {
  final int capacity;
  final LinkedHashMap<K, V> _map = LinkedHashMap();

  LRUCache(this.capacity) {
    if (capacity <= 0) throw ArgumentError('capacity must be positive');
  }

  V? get(K key) {
    if (!_map.containsKey(key)) return null;
    final v = _map.remove(key) as V;
    _map[key] = v;
    return v;
  }

  void put(K key, V value) {
    if (_map.containsKey(key)) _map.remove(key);
    else if (_map.length >= capacity) _map.remove(_map.keys.first);
    _map[key] = value;
  }

  int get length => _map.length;
  List<K> orderMRUFirst() => _map.keys.toList().reversed.toList();
}

void main() {
  final cache = LRUCache<String, int>(3);
  cache.put('a', 1);
  cache.put('b', 2);
  cache.put('c', 3);
  cache.get('a');              // 'a' becomes most recent
  cache.put('d', 4);           // evicts 'b'
  print(cache.orderMRUFirst()); // [d, a, c]
  print(cache.get('b'));        // null
}
