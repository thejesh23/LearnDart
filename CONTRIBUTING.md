# Contributing to LearnDart

Thanks for helping grow the collection. This repo follows a few simple conventions so learners can browse it easily and so the git history stays useful as a learning artifact of its own.

## File conventions

1. **One concept per file.** If a topic can be split into two independent pieces, make two files.
2. **Every file is runnable.** Include a `main()` function that demonstrates the code. A reader should be able to `dart run <path>` any file in the repo and see output.
3. **`basics/` files include teaching comments.** Explain *what* the code does and *why*, in plain English, for a first-time learner. Algorithm files stay clean — comment only when the *why* is non-obvious.
4. **Sound null safety, Dart 3.x idioms.** Use records, patterns, and switch expressions where they make the code clearer.
5. **No dependencies.** Every sample runs against the Dart SDK alone. If a sample truly needs a package, open an issue first.

## Commit conventions

- **One file per commit** whenever the file stands alone.
- **Break a sample into multiple commits** when it contains independently understandable pieces — e.g. an iterative version and a recursive version of the same algorithm.
- **Commit message format:** `Add: <path> — <one-line what it teaches>`
  - Example: `Add: sorts/bubble_sort.dart — iterative bubble sort with in-place swap`

## Naming

- Directories: `snake_case` and numeric-prefixed only inside `basics/` (to enforce reading order).
- Files: `snake_case.dart`, descriptive over clever. `binary_search_recursive.dart` beats `bsr.dart`.

## Before opening a PR

- Run `dart format .` on your files.
- Run `dart analyze` and fix any warnings.
- Update `DIRECTORY.md` if you added new files (or regenerate it if a helper script exists).
