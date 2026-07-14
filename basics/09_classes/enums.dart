// An `enum` is a fixed set of named values. Dart's enhanced enums can also
// carry data and behavior — they're more than just labels.
enum Direction {
  north(dx: 0, dy: -1),
  east(dx: 1, dy: 0),
  south(dx: 0, dy: 1),
  west(dx: -1, dy: 0);

  final int dx;
  final int dy;

  const Direction({required this.dx, required this.dy});

  Direction turnRight() => switch (this) {
        Direction.north => Direction.east,
        Direction.east => Direction.south,
        Direction.south => Direction.west,
        Direction.west => Direction.north,
      };
}

void main() {
  final facing = Direction.north;
  print('facing = $facing (dx=${facing.dx}, dy=${facing.dy})');
  print('after right turn: ${facing.turnRight()}');
  print('all directions: ${Direction.values}');
}
