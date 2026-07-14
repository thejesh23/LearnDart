// A `Set` is an unordered collection where every value appears at most
// once. Use it when uniqueness matters — for example, "the distinct tags
// across all posts".
void main() {
  Set<String> tags = {'dart', 'flutter', 'dart'}; // duplicate 'dart' dropped
  print('tags       = $tags');
  print('contains flutter? ${tags.contains("flutter")}');

  tags.add('mobile');
  tags.remove('dart');
  print('after edits: $tags');

  // Set algebra:
  Set<int> a = {1, 2, 3, 4};
  Set<int> b = {3, 4, 5, 6};
  print('union       : ${a.union(b)}');
  print('intersection: ${a.intersection(b)}');
  print('difference  : ${a.difference(b)}');
}
