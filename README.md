# LearnDart

> A hands-on collection of small, runnable Dart programs — from your first `Hello, world!` to classic algorithms — written for two audiences at once.

[![Dart SDK](https://img.shields.io/badge/Dart-%5E3.4-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)
[![Style: Dart](https://img.shields.io/badge/style-dart--format-blue.svg)](https://dart.dev/tools/dart-format)

Inspired by [TheAlgorithms/Python](https://github.com/TheAlgorithms/Python). Every file in this repository is a self-contained lesson: you can open it, read it top-to-bottom, and run it with a single command.

---

## Table of contents

- [Why LearnDart?](#why-learndart)
- [Who this is for](#who-this-is-for)
- [Quick start](#quick-start)
- [The learning path (basics/)](#the-learning-path-basics)
- [Algorithm categories](#algorithm-categories)
- [A taste of the code](#a-taste-of-the-code)
- [How this repo is organized](#how-this-repo-is-organized)
- [Repository conventions](#repository-conventions)
- [Roadmap](#roadmap)
- [Contributing](#contributing)
- [Inspiration](#inspiration)
- [License](#license)

---

## Why LearnDart?

Most language tutorials fall into one of two traps: they either bury you in features before you can write a program, or they hand you a giant final application with no explanation of the pieces. LearnDart takes a third path — **one concept per file, one file per commit**. You can read the code, the comments, and (if you want) the git history and see exactly how the language was introduced, in order.

- **Read it as a book** — walk through `basics/` in order, no setup beyond installing Dart.
- **Read it as a reference** — jump straight to `sorts/`, `graphs/`, `dynamic_programming/`, etc. when you need a Dart implementation of a classic algorithm.
- **Read it as a git log** — every commit is atomic and titled `Add: <path> — <what it teaches>`.

## Who this is for

| Audience | Where to start | What you'll get |
|----------|----------------|-----------------|
| **Non-programmers** learning to code for the first time | [`basics/00_hello_world/`](basics/00_hello_world/) | Files are numbered `00`, `01`, `02`... so you always know the next step. Each `basics/` file has plain-English comments that explain *what* the code does and *why*. |
| **Programmers** coming from Python, JavaScript, Go, Java, C# or similar | [`basics/08_null_safety/`](basics/08_null_safety/), then the algorithm categories | Skim the `basics/` folders for Dart-specific idioms (sound null safety, records, patterns, `async`/`await`, mixins), then dive into idiomatic Dart implementations of algorithms you already know. |
| **CS students** looking for clean reference implementations | Any algorithm category below | Every algorithm is a small, focused file with a `main()` that exercises it. No frameworks, no packages — just Dart and the SDK. |

## Quick start

1. **Install Dart** — see [dart.dev/get-dart](https://dart.dev/get-dart). Any Dart SDK `3.4.0` or newer works.
2. **Clone the repo:**

   ```bash
   git clone https://github.com/thejesh23/LearnDart.git
   cd LearnDart
   ```

3. **Run any file:**

   ```bash
   dart run basics/00_hello_world/hello_world.dart
   ```

That's the whole workflow. There is no build step, no `pub get`, no packages to install — the repo has zero third-party dependencies.

## The learning path (`basics/`)

Follow the numbered folders in order. Inside each folder, read the files in alphabetical order.

| # | Folder | You'll learn | Files |
|---|--------|--------------|-------|
| 00 | [`00_hello_world/`](basics/00_hello_world/) | `main()`, `print`, running a Dart file | 1 |
| 01 | [`01_variables/`](basics/01_variables/) | `var`, `final` vs `const`, `late` initialization | 3 |
| 02 | [`02_types/`](basics/02_types/) | `int`, `double`, `String`, `bool`, `Object`, `dynamic`, inference | 5 |
| 03 | [`03_operators/`](basics/03_operators/) | Arithmetic, comparison, logical, null-aware operators | 4 |
| 04 | [`04_strings/`](basics/04_strings/) | Interpolation, multiline / raw strings, common methods | 3 |
| 05 | [`05_control_flow/`](basics/05_control_flow/) | `if`/`else`, `switch` statement & expression, `for`, `while`, `do-while`, `break`/`continue` | 7 |
| 06 | [`06_functions/`](basics/06_functions/) | Positional & named parameters, arrow syntax, higher-order functions, closures | 6 |
| 07 | [`07_collections/`](basics/07_collections/) | `List`, `Set`, `Map`, iteration, spread operator, collection-if/for | 7 |
| 08 | [`08_null_safety/`](basics/08_null_safety/) | Nullable types, flow-based narrowing, the `!` operator | 3 |
| 09 | [`09_classes/`](basics/09_classes/) | Fields, constructors, getters/setters, inheritance, abstract classes, mixins, enums | 8 |
| 10 | [`10_async/`](basics/10_async/) | `Future`, `async`/`await`, `Stream` and `async*` generators | 3 |
| 11 | [`11_errors/`](basics/11_errors/) | `try`/`catch`/`finally`, throwing exceptions, custom exception types | 3 |

## Algorithm categories

Once you're comfortable with the language, these folders contain clean, standalone implementations of the classics. Each file is a tiny module: a couple of top-level functions and a `main()` that demonstrates them.

### [`sorts/`](sorts/) — sorting algorithms

| File | Idea | Time |
|------|------|------|
| [`bubble_sort.dart`](sorts/bubble_sort.dart) | Repeated adjacent-pair swap with early-exit | O(n²) |
| [`selection_sort.dart`](sorts/selection_sort.dart) | Repeatedly pick the minimum from the unsorted tail | O(n²) |
| [`insertion_sort.dart`](sorts/insertion_sort.dart) | Grow a sorted prefix one element at a time | O(n²) |
| [`merge_sort.dart`](sorts/merge_sort.dart) | Divide-and-conquer with a linear-time merge | O(n log n) |
| [`quick_sort.dart`](sorts/quick_sort.dart) | Lomuto partition, in-place recursion | O(n log n) avg |
| [`heap_sort.dart`](sorts/heap_sort.dart) | Max-heapify, then repeatedly extract the maximum | O(n log n) |
| [`counting_sort.dart`](sorts/counting_sort.dart) | Non-comparison sort for bounded integer ranges | O(n + k) |
| [`shell_sort.dart`](sorts/shell_sort.dart) | Gapped insertion sort with halving gap sequence | O(n²) worst |

### [`searches/`](searches/) — search algorithms

| File | Idea | Precondition |
|------|------|--------------|
| [`linear_search.dart`](searches/linear_search.dart) | Sequential scan for the target | — |
| [`binary_search.dart`](searches/binary_search.dart) | Iterative O(log n) half-interval search | sorted |
| [`binary_search_recursive.dart`](searches/binary_search_recursive.dart) | Recursive variant of binary search | sorted |
| [`ternary_search.dart`](searches/ternary_search.dart) | Split the range into thirds each iteration | sorted |
| [`jump_search.dart`](searches/jump_search.dart) | √n block jumps followed by a linear scan | sorted |

### [`data_structures/`](data_structures/) — the classics

| File | What it is |
|------|------------|
| [`stack.dart`](data_structures/stack.dart) | Generic LIFO with `push`, `pop`, `peek` |
| [`queue.dart`](data_structures/queue.dart) | Generic FIFO backed by `dart:collection` `Queue` |
| [`linked_list.dart`](data_structures/linked_list.dart) | Singly linked list |
| [`doubly_linked_list.dart`](data_structures/doubly_linked_list.dart) | Doubly linked list with bidirectional traversal |
| [`binary_tree.dart`](data_structures/binary_tree.dart) | Pre-, in- and post-order traversals |
| [`binary_search_tree.dart`](data_structures/binary_search_tree.dart) | BST with `insert`, `contains`, in-order enumeration |
| [`hash_table.dart`](data_structures/hash_table.dart) | Open hash table with per-bucket chaining |
| [`min_heap.dart`](data_structures/min_heap.dart) | Array-backed min-heap with sift-up / sift-down |
| [`graph_adjacency_list.dart`](data_structures/graph_adjacency_list.dart) | Undirected graph via `Map<T, Set<T>>` |

### [`maths/`](maths/) — number theory & arithmetic

| File | Topic |
|------|-------|
| [`gcd.dart`](maths/gcd.dart) / [`gcd_recursive.dart`](maths/gcd_recursive.dart) | Iterative and recursive Euclidean algorithm |
| [`lcm.dart`](maths/lcm.dart) | Least common multiple via gcd |
| [`factorial_iterative.dart`](maths/factorial_iterative.dart) / [`factorial_recursive.dart`](maths/factorial_recursive.dart) | Factorial using `BigInt` |
| [`fibonacci_iterative.dart`](maths/fibonacci_iterative.dart) / [`fibonacci_recursive.dart`](maths/fibonacci_recursive.dart) / [`fibonacci_memoized.dart`](maths/fibonacci_memoized.dart) | Three ways to compute Fibonacci — with cost comparisons in the comments |
| [`is_prime.dart`](maths/is_prime.dart) | Trial division up to √n |
| [`sieve_of_eratosthenes.dart`](maths/sieve_of_eratosthenes.dart) | Generate primes up to a limit |
| [`power_iterative.dart`](maths/power_iterative.dart) / [`power_recursive.dart`](maths/power_recursive.dart) | Exponentiation by squaring |

### [`strings/`](strings/) — string algorithms

- [`reverse_string.dart`](strings/reverse_string.dart) — reverse code units via runes
- [`is_palindrome.dart`](strings/is_palindrome.dart) — two-pointer palindrome check
- [`is_anagram.dart`](strings/is_anagram.dart) — sort-and-compare anagram check
- [`word_count.dart`](strings/word_count.dart) — tally word occurrences via regex split
- [`character_frequency.dart`](strings/character_frequency.dart) — per-character occurrence map

### [`ciphers/`](ciphers/) — classical ciphers

- [`caesar_cipher.dart`](ciphers/caesar_cipher.dart) — alphabetic shift cipher with decoder
- [`rot13.dart`](ciphers/rot13.dart) — Caesar with a fixed shift of 13 (self-inverse)
- [`vigenere_cipher.dart`](ciphers/vigenere_cipher.dart) — keyed polyalphabetic cipher

### [`dynamic_programming/`](dynamic_programming/) — DP classics

- [`fibonacci_dp.dart`](dynamic_programming/fibonacci_dp.dart) — bottom-up tabulated Fibonacci
- [`knapsack_01.dart`](dynamic_programming/knapsack_01.dart) — 0/1 knapsack via 2-D DP
- [`longest_common_subsequence.dart`](dynamic_programming/longest_common_subsequence.dart) — LCS length via 2-D DP
- [`coin_change.dart`](dynamic_programming/coin_change.dart) — minimum coins to make a target amount

### [`graphs/`](graphs/) — graph algorithms

- [`bfs.dart`](graphs/bfs.dart) — breadth-first traversal with a queue and visited set
- [`dfs.dart`](graphs/dfs.dart) — recursive depth-first traversal
- [`dijkstra.dart`](graphs/dijkstra.dart) — shortest paths for non-negative edge weights

### [`recursion/`](recursion/) — classic recursion

- [`tower_of_hanoi.dart`](recursion/tower_of_hanoi.dart) — three-peg disk transfer
- [`permutations.dart`](recursion/permutations.dart) — enumerate all orderings of a list
- [`combinations.dart`](recursion/combinations.dart) — enumerate k-element subsets

See [DIRECTORY.md](DIRECTORY.md) for a flat alphabetical index of every file.

## A taste of the code

**Your first Dart program** — [`basics/00_hello_world/hello_world.dart`](basics/00_hello_world/hello_world.dart):

```dart
// Every Dart program starts running from a function called `main`.
void main() {
  print('Hello, world!');
}
```

```console
$ dart run basics/00_hello_world/hello_world.dart
Hello, world!
```

**Dart 3 switch expression with patterns** — [`basics/05_control_flow/switch_expression.dart`](basics/05_control_flow/switch_expression.dart):

```dart
String describe(int n) => switch (n) {
      0 => 'zero',
      1 || 2 || 3 => 'small',
      < 0 => 'negative',
      _ => 'large or unusual',
    };
```

**A generic stack** — [`data_structures/stack.dart`](data_structures/stack.dart):

```dart
class Stack<T> {
  final List<T> _items = [];
  void push(T v) => _items.add(v);
  T pop() => _items.removeLast();
  T peek() => _items.last;
  bool get isEmpty => _items.isEmpty;
}
```

**Fibonacci — three ways**, side by side in [`maths/`](maths/):

```dart
// fibonacci_iterative.dart  — O(n) time, O(1) space
int fib(int n) {
  int a = 0, b = 1;
  for (int i = 2; i <= n; i++) { final c = a + b; a = b; b = c; }
  return b;
}

// fibonacci_recursive.dart  — O(2^n), for pedagogical contrast
int fib(int n) => n < 2 ? n : fib(n - 1) + fib(n - 2);

// fibonacci_memoized.dart   — recursion + cache, back to O(n)
final _cache = {0: BigInt.zero, 1: BigInt.one};
BigInt fib(int n) => _cache[n] ??= fib(n - 1) + fib(n - 2);
```

## How this repo is organized

```text
LearnDart/
├── basics/                 numbered teaching folders 00_ ... 11_
│   ├── 00_hello_world/
│   ├── 01_variables/
│   ├── 02_types/
│   └── ...
├── sorts/                  one algorithm per file
├── searches/
├── data_structures/
├── maths/
├── strings/
├── ciphers/
├── dynamic_programming/
├── graphs/
├── recursion/
├── DIRECTORY.md            flat index of every .dart file
├── CONTRIBUTING.md         file and commit conventions
├── LICENSE                 MIT
├── README.md               you are here
└── pubspec.yaml            Dart SDK constraint, no dependencies
```

## Repository conventions

- **One concept per file.** Splittable? Split it.
- **One file per commit.** The git history *is* the reading order.
- **Every file runs.** No file exists without a `main()` you can execute directly.
- **Zero dependencies.** Every sample runs against the pure Dart SDK.
- **`basics/` files teach.** They have prose comments explaining the *what* and the *why*.
- **Algorithm files stay clean.** They only comment when the *why* is non-obvious.
- **Iterative + recursive = two commits.** Same algorithm, two shapes — they get their own files.

Full details in [CONTRIBUTING.md](CONTRIBUTING.md).

## Roadmap

More samples land in later sessions. Planned expansions:

- **More sorts** — radix, bucket, timsort, tree sort
- **More searches** — interpolation, exponential, Fibonacci search
- **More data structures** — trie, AVL/red-black trees, disjoint set union, segment tree, Fenwick tree, LRU cache
- **More graph algorithms** — Bellman-Ford, Floyd-Warshall, Prim, Kruskal, topological sort, Union-Find
- **More DP** — edit distance, matrix chain multiplication, longest increasing subsequence, rod cutting
- **New categories** — `bit_manipulation/`, `backtracking/`, `greedy/`, `number_theory/`, `geometry/`
- **Classic problems** — N-queens, sudoku, maze solvers, sliding-window puzzles
- **Advanced Dart** — isolates, `dart:io` file & socket samples, FFI

## Contributing

New samples are always welcome. Please read [CONTRIBUTING.md](CONTRIBUTING.md) first — the short version:

1. One concept per file. Splittable? Split it.
2. One file per commit. Commit message format: `Add: <path> — <one-line what it teaches>`.
3. `dart format .` before you submit.
4. `dart analyze` is clean.
5. Update `DIRECTORY.md` when you add files.

## Inspiration

- [TheAlgorithms/Python](https://github.com/TheAlgorithms/Python) — the model for the algorithm categories.
- [dart.dev/language](https://dart.dev/language) — canonical reference for every language feature covered in `basics/`.

## License

Released under the [MIT License](LICENSE).
