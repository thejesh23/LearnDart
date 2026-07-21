// Bytecode compiler — translates the AST into a flat list of
// instructions for a stack-based virtual machine (compilers/vm.dart).
//
// Why compile instead of tree-walk?
//   The tree-walker (interpreter.dart) traverses pointer-chasing nodes
//   on every evaluation. A bytecode VM executes a flat integer array:
//   no pointer chasing, predictable branch targets, easy to serialise.
//   Real language runtimes (CPython, the JVM, Lua, V8 before JIT) all
//   pass through a bytecode stage for this reason.
//
// Instruction set (stack-based):
//   PUSH v    — push literal value v onto the value stack
//   LOAD n    — push the value of variable n (looked up in the frame)
//   STORE n   — pop the top value, bind it to variable n in the frame
//   ADD/SUB/MUL/DIV  — pop two values, push their result
//   JUMP_IF_ZERO offset  — pop top; if zero, jump by offset
//   JUMP offset          — unconditional jump by offset
//   HALT      — stop execution; top of stack is the result
//
// Compilation rules:
//   Num(v)            → PUSH v
//   Var(n)            → LOAD n
//   BinOp(op,l,r)    → compile(l) ++ compile(r) ++ [op_instr]
//   Let(n,val,body)  → compile(val) ++ STORE n ++ compile(body)
//   If(c,t,e)        → compile(c)
//                      JUMP_IF_ZERO (len(t)+2)
//                      compile(t) ++ JUMP (len(e)+1)
//                      compile(e)
//
// The output `Chunk` (list of `Instruction`s) is executed by vm.dart.

import 'ast.dart';

// ----- instruction set --------------------------------------------------

enum OpCode { push, load, store, add, sub, mul, div, jumpIfZero, jump, halt }

class Instruction {
  final OpCode op;
  final double? numArg;   // for PUSH
  final String? strArg;   // for LOAD / STORE
  final int?    intArg;   // for JUMP / JUMP_IF_ZERO (relative offset)

  const Instruction._(this.op, {this.numArg, this.strArg, this.intArg});

  factory Instruction.push(double v)    => Instruction._(OpCode.push,        numArg: v);
  factory Instruction.load(String n)    => Instruction._(OpCode.load,        strArg: n);
  factory Instruction.store(String n)   => Instruction._(OpCode.store,       strArg: n);
  factory Instruction.add()             => const Instruction._(OpCode.add);
  factory Instruction.sub()             => const Instruction._(OpCode.sub);
  factory Instruction.mul()             => const Instruction._(OpCode.mul);
  factory Instruction.div()             => const Instruction._(OpCode.div);
  factory Instruction.jump(int offset)        => Instruction._(OpCode.jump,        intArg: offset);
  factory Instruction.jumpIfZero(int offset)  => Instruction._(OpCode.jumpIfZero,  intArg: offset);
  static const halt = Instruction._(OpCode.halt);

  @override
  String toString() => switch (op) {
    OpCode.push        => 'PUSH    ${numArg!}',
    OpCode.load        => 'LOAD    $strArg',
    OpCode.store       => 'STORE   $strArg',
    OpCode.add         => 'ADD',
    OpCode.sub         => 'SUB',
    OpCode.mul         => 'MUL',
    OpCode.div         => 'DIV',
    OpCode.jump        => 'JUMP    +$intArg',
    OpCode.jumpIfZero  => 'JZ      +$intArg',
    OpCode.halt        => 'HALT',
  };
}

typedef Chunk = List<Instruction>;

// ----- compiler ---------------------------------------------------------

Chunk compile(Expr expr) {
  final out = <Instruction>[];
  _compile(expr, out);
  out.add(Instruction.halt);
  return out;
}

void _compile(Expr expr, Chunk out) {
  switch (expr) {
    case Num(:final value):
      out.add(Instruction.push(value));

    case Var(:final name):
      out.add(Instruction.load(name));

    case BinOp(:final op, :final left, :final right):
      _compile(left, out);
      _compile(right, out);
      out.add(switch (op) {
        '+' => Instruction.add(),
        '-' => Instruction.sub(),
        '*' => Instruction.mul(),
        '/' => Instruction.div(),
        _   => throw StateError('unknown op: $op'),
      });

    case Let(:final name, :final value, :final body):
      _compile(value, out);
      out.add(Instruction.store(name));
      _compile(body, out);

    case If(:final cond, :final then_, :final else_):
      // Compile condition
      _compile(cond, out);

      // Placeholder for JZ — we'll patch the offset once we know the
      // size of the then-branch.
      final jzIdx = out.length;
      out.add(Instruction.jumpIfZero(0));  // placeholder

      // Compile then-branch
      _compile(then_, out);

      // Unconditional jump over the else-branch
      final jmpIdx = out.length;
      out.add(Instruction.jump(0));  // placeholder

      // Patch JZ: jump to instruction after the JUMP (= start of else)
      out[jzIdx] = Instruction.jumpIfZero(out.length - jzIdx - 1);

      // Compile else-branch
      _compile(else_, out);

      // Patch JUMP: jump to instruction after else-branch
      out[jmpIdx] = Instruction.jump(out.length - jmpIdx - 1);
  }
}

/// Disassemble a chunk for debugging.
void disassemble(Chunk chunk, [String label = 'chunk']) {
  print('=== $label ===');
  for (int i = 0; i < chunk.length; i++) {
    print('  ${i.toString().padLeft(3)}  ${chunk[i]}');
  }
}

void main() {
  // let x = 6 in let y = 7 in x * y
  final prog = let('x', num(6), let('y', num(7), mul(v('x'), v('y'))));
  disassemble(compile(prog), 'let x=6 in let y=7 in x*y');

  print('');

  // if (5 - 5) then 42 else 0
  final cond = iff(sub(num(5), num(5)), num(42), num(0));
  disassemble(compile(cond), 'if (5-5) then 42 else 0');
}
