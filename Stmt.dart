import 'Expr.dart';

abstract class StmtVisitor<TYPE_NAME> {
  TYPE_NAME visitExpressionStmt(Expression stmt);
  TYPE_NAME visitPrintStmt(Print stmt);
}

abstract class Stmt<TYPE_NAME> {
  TYPE_NAME accept(StmtVisitor<TYPE_NAME> visitor);
}

class Expression<TYPE_NAME> extends Stmt<TYPE_NAME> {
  Expression(Expr expression) : 
    this.expression = expression
  {}

  TYPE_NAME accept(StmtVisitor<TYPE_NAME> visitor) {
    return visitor.visitExpressionStmt(this);
  }

  Expr expression;
}

class Print<TYPE_NAME> extends Stmt<TYPE_NAME> {
  Print(Expr expression) : 
    this.expression = expression
  {}

  TYPE_NAME accept(StmtVisitor<TYPE_NAME> visitor) {
    return visitor.visitPrintStmt(this);
  }

  Expr expression;
}

