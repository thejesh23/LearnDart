// A tour of the common list operations you'll reach for daily.
void main() {
  List<int> nums = [1, 2, 3];

  nums.add(4);              // [1, 2, 3, 4]
  nums.insert(0, 0);        // [0, 1, 2, 3, 4]
  nums.remove(2);           // removes the first occurrence of the value 2
  nums.removeAt(0);         // removes by index
  print('after edits: $nums');

  // Transformations return new iterables, leaving the original alone.
  final doubled = nums.map((n) => n * 2).toList();
  final evens = nums.where((n) => n % 2 == 0).toList();
  final sum = nums.fold(0, (acc, n) => acc + n);

  print('doubled : $doubled');
  print('evens   : $evens');
  print('sum     : $sum');

  // Sort in place.
  final scores = [42, 7, 100, 3, 88];
  scores.sort();
  print('sorted  : $scores');
}
