// Least Recently Used cache: fixed-capacity key-value store that
// evicts the least recently accessed entry when full.
//
// Classic implementation is a doubly linked list of entries plus a
// hash map from key to node — get() moves the accessed node to the
// front, put() inserts at the front and evicts from the back. This
// implementation piggybacks on Dart's LinkedHashMap, which is
// exactly that structure internally (insertion-order iteration).
//
// Ubiquitous: browser page caches, OS page replacement (approximated
// via clock or ARC because true LRU is expensive at OS scale),
// application-level query result caches, CPU cache eviction policies
// (approximated). All O(1) time per operation.
//
// Alternatives to LRU worth knowing: LFU (least frequently used),
// FIFO, ARC (adaptive replacement, Netflix Hollow), TinyLFU.
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
