// Stack-based virtual machine — executes the bytecode produced by
// compilers/compiler.dart. Completes the compiler pipeline:
//
//   source text  →  tokens (parsers/)  →  AST (ast.dart)
//   AST  →  bytecode (compiler.dart)  →  result (this file)
//
// Why a stack VM (vs register VM)?
//   Stack VMs need no register allocator — the compiler never names
//   temporaries, it just pushes and pops. This makes the compiler
//   trivial to write. The JVM, the CLR (.NET), CPython, and the Wasm
//   spec all chose stack VMs for exactly this reason.
//   Register VMs (Lua 5, Dalvik/ART) squeeze more performance by
//   reducing push/pop traffic; the trade-off is a more complex compiler.
//
// Execution model:
//   - A value stack holds doubles.
//   - A variable frame (Map<String, double>) holds named bindings
//     created by STORE and read by LOAD.
//   - An instruction pointer (ip) steps through the Chunk sequentially,
//     except when JUMP or JUMP_IF_ZERO redirect it.
//
// Instruction semantics:
//   PUSH v          → stack.push(v)
//   LOAD n          → stack.push(frame[n])
//   STORE n         → frame[n] = stack.pop()
//   ADD             → b=pop(), a=pop(), push(a+b)
//   SUB             → b=pop(), a=pop(), push(a-b)
//   MUL / DIV       → same pattern
//   JUMP_IF_ZERO k  → v=pop(); if v==0, ip += k
//   JUMP k          → ip += k
//   HALT            → stop; stack.top is the result

import 'ast.dart';
import 'compiler.dart';

class VM {
  final List<double> _stack = [];
  final Map<String, double> _frame = {};

  double run(Chunk chunk) {
    _stack.clear();
    _frame.clear();
    int ip = 0;

    while (ip < chunk.length) {
      final instr = chunk[ip];
      switch (instr.op) {
        case OpCode.push:
          _stack.add(instr.numArg!);

        case OpCode.load:
          final val = _frame[instr.strArg!];
          if (val == null) throw StateError('unbound variable: ${instr.strArg}');
          _stack.add(val);

        case OpCode.store:
          _frame[instr.strArg!] = _stack.removeLast();

        case OpCode.add:
          final b = _stack.removeLast(), a = _stack.removeLast();
          _stack.add(a + b);

        case OpCode.sub:
          final b = _stack.removeLast(), a = _stack.removeLast();
          _stack.add(a - b);

        case OpCode.mul:
          final b = _stack.removeLast(), a = _stack.removeLast();
          _stack.add(a * b);

        case OpCode.div:
          final b = _stack.removeLast(), a = _stack.removeLast();
          _stack.add(a / b);

        case OpCode.jumpIfZero:
          final v = _stack.removeLast();
          if (v == 0) ip += instr.intArg!;

        case OpCode.jump:
          ip += instr.intArg!;

        case OpCode.halt:
          return _stack.last;
      }
      ip++;
    }
    throw StateError('program ended without HALT');
  }
}

double execute(Expr expr) => VM().run(compile(expr));

void main() {
  // Run every example through the full pipeline and compare against
  // the interpreter (compilers/interpreter.dart) results.
  void check(String desc, Expr expr, double expected) {
    final result = execute(expr);
    final ok = (result - expected).abs() < 1e-9;
    print('${ok ? "✓" : "✗"}  $desc  →  $result  (expected $expected)');
  }

  // 1. Arithmetic
  check('3 + 4 * 2', add(num(3), mul(num(4), num(2))), 11.0);

  // 2. Let binding
  check('let x = 10 in x * x',
      let('x', num(10), mul(v('x'), v('x'))), 100.0);

  // 3. Nested let — inner x shadows outer
  check('let x=1 in (let x=2 in x) + x',
      let('x', num(1),
        add(let('x', num(2), v('x')),
            v('x'))), 3.0);

  // 4. If — zero is falsy, non-zero is truthy
  check('if (5-5) then 42 else 0',
      iff(sub(num(5), num(5)), num(42), num(0)), 0.0);

  check('if (1) then 42 else 0',
      iff(num(1), num(42), num(0)), 42.0);

  // 5. Division
  check('10 / 4', div(num(10), num(4)), 2.5);

  print('\n--- Disassembly of let x=6 in let y=7 in x*y ---');
  disassemble(compile(let('x', num(6), let('y', num(7), mul(v('x'), v('y'))))));
}
