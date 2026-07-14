# LearnDart

A collection of small, runnable Dart programs — from `Hello, world!` to classic algorithms — designed for two audiences:

- **Non-programmers** learning to code for the first time: start in [`basics/`](basics/). Each file teaches one concept, in order, with plain-English comments explaining what the code does and why.
- **Programmers** coming from another language: skim `basics/` for Dart-specific idioms (null safety, records, patterns, async), then jump into the algorithm categories below to see idiomatic Dart implementations of the classics.

Inspired by [TheAlgorithms/Python](https://github.com/TheAlgorithms/Python).

## How to run any file

Install Dart from [dart.dev/get-dart](https://dart.dev/get-dart), then:

```bash
dart run basics/00_hello_world/hello_world.dart
```

Every `.dart` file in this repo is a standalone script with a `main()` function you can run directly.

## Categories

- [`basics/`](basics/) — the teaching track (start here if you're new)
- [`sorts/`](sorts/) — bubble, selection, insertion, merge, quick, heap, ...
- [`searches/`](searches/) — linear, binary, ternary, jump, ...
- [`data_structures/`](data_structures/) — stack, queue, linked list, tree, hash table, heap, graph
- [`maths/`](maths/) — GCD, LCM, primes, Fibonacci, sieve, ...
- [`strings/`](strings/) — reverse, palindrome, anagram, frequency, ...
- [`ciphers/`](ciphers/) — Caesar, Vigenère, ROT13, ...
- [`dynamic_programming/`](dynamic_programming/) — knapsack, LCS, coin change, ...
- [`graphs/`](graphs/) — BFS, DFS, Dijkstra, ...
- [`recursion/`](recursion/) — Tower of Hanoi, permutations, combinations, ...

See [DIRECTORY.md](DIRECTORY.md) for a full index of every file.

## Contributing

New samples are always welcome. Read [CONTRIBUTING.md](CONTRIBUTING.md) for the file-and-commit conventions this repo follows (short version: one concept per file, one file per commit).

## License

[MIT](LICENSE)
