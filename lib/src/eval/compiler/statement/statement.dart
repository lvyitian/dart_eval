import 'package:analyzer/dart/ast/ast.dart';
import 'package:dart_eval/src/eval/compiler/context.dart';
import 'package:dart_eval/src/eval/compiler/errors.dart';
import 'package:dart_eval/src/eval/compiler/expression/expression.dart';
import 'package:dart_eval/src/eval/compiler/statement/for.dart';
import 'package:dart_eval/src/eval/compiler/statement/return.dart';
import 'package:dart_eval/src/eval/compiler/statement/variable_declaration.dart';
import 'package:dart_eval/src/eval/compiler/type.dart';

import 'block.dart';

StatementInfo compileStatement(Statement s, AlwaysReturnType? expectedReturnType, CompilerContext ctx) {
  if (s is Block) {
    return compileBlock(s, expectedReturnType, ctx);
  } else if (s is VariableDeclarationStatement) {
    return compileVariableDeclarationStatement(s, ctx);
  } else if (s is ExpressionStatement) {
    compileExpression(s.expression, ctx);
    return StatementInfo(-1);
  } else if (s is ReturnStatement) {
    return compileReturn(ctx, s, expectedReturnType);
  } else if (s is ForStatement) {
    return compileForStatement(s, ctx, expectedReturnType);
  } else {
    throw CompileError('Unknown statement type ${s.runtimeType}');
  }
}

class StatementInfo {
  StatementInfo(this.position, {this.willAlwaysReturn = false, this.willAlwaysThrow = false});

  final int position;
  final bool willAlwaysReturn;
  final bool willAlwaysThrow;
}