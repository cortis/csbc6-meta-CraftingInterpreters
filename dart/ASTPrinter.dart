import 'Expr.dart';
import 'Token.dart';

class ASTPrinter implements ExprVisitor<String> {
  String print(Expr expr) {
    return expr.accept(this);
  }

  String visitBinaryExpr(Binary expr) {
    return parenthesize(expr.operator.lexeme, [expr.left, expr.right]);
  }

  String visitGroupingExpr(Grouping expr) {
    return parenthesize("group", [expr.expression]);
  }

  String visitLiteralExpr(Literal expr) {
    if (expr.value == null) return "nil";
    return expr.value.toString();
  }

  String visitUnaryExpr(Unary expr) {
    return parenthesize(expr.operator.lexeme, [expr.right]);
  }

  @override
  String visitVariableExpr(Variable expr) {
    // TODO: implement visitVariableExpr
    throw UnimplementedError();
  }

  @override
  String visitAssignExpr(Assign expr) {
    // TODO: implement visitAssignExpr
    throw UnimplementedError();
  }

  @override
  String visitLogicalExpr(Logical expr) {
    // TODO: implement visitLogicalExpr
    throw UnimplementedError();
  }

  String parenthesize(String name, List<Expr> exprs) {
    var buffer = new StringBuffer();

    buffer.write("(");
    buffer.write(name);
    for (Expr expr in exprs) {
      buffer.write(" ");
      buffer.write(expr.accept(this));
    }
    buffer.write(")");

    return buffer.toString();
  }
  
  @override
  String visitCallExpr(Call expr) {
    // TODO: implement visitCallExpr
    throw UnimplementedError();
  }
}

void main(List<String> args) {
  Expr expression = new Binary(
      new Unary(
        new Token(TokenType.MINUS, "-", null, 1),
        new Literal(123)),
      new Token(TokenType.STAR, "*", null, 1),
      new Grouping(new Literal(45.67)));

  print(new ASTPrinter().print(expression));
}
