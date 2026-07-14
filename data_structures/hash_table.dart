class HashTable<K, V> {
  final List<List<MapEntry<K, V>>> _buckets;
  int _size = 0;

  HashTable([int capacity = 16])
      : _buckets = List.generate(capacity, (_) => <MapEntry<K, V>>[]);

  int _bucketIndex(K key) => key.hashCode.abs() % _buckets.length;

  void put(K key, V value) {
    final b = _buckets[_bucketIndex(key)];
    for (int i = 0; i < b.length; i++) {
      if (b[i].key == key) {
        b[i] = MapEntry(key, value);
        return;
      }
    }
    b.add(MapEntry(key, value));
    _size++;
  }

  V? get(K key) {
    final b = _buckets[_bucketIndex(key)];
    for (final e in b) {
      if (e.key == key) return e.value;
    }
    return null;
  }

  bool remove(K key) {
    final b = _buckets[_bucketIndex(key)];
    for (int i = 0; i < b.length; i++) {
      if (b[i].key == key) {
        b.removeAt(i);
        _size--;
        return true;
      }
    }
    return false;
  }

  int get size => _size;
}

void main() {
  final h = HashTable<String, int>();
  h.put('one', 1);
  h.put('two', 2);
  h.put('three', 3);
  print(h.get('two'));    // 2
  h.remove('one');
  print(h.get('one'));    // null
  print('size: ${h.size}');
}
