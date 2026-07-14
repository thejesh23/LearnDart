// You can put `if` and `for` *inside* a collection literal to conditionally
// include or generate elements. This lets you build collections declaratively
// instead of pushing to an empty list in a loop.
void main() {
  bool includeAdmin = true;
  List<String> roles = [
    'user',
    'guest',
    if (includeAdmin) 'admin',
  ];
  print('roles: $roles');

  List<int> squares = [
    for (int i = 1; i <= 5; i++) i * i,
  ];
  print('squares: $squares');

  // Combine them.
  List<int> evenSquares = [
    for (int i = 1; i <= 5; i++)
      if (i % 2 == 0) i * i,
  ];
  print('even squares: $evenSquares');
}
