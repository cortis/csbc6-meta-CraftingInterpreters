import 'Expr.dart';
import 'Token.dart';

abstract class StmtVisitor<TYPE_NAME> {
  TYPE_NAME visitBlockStmt(Block stmt);
  TYPE_NAME visitExpressionStmt(Expression stmt);
  TYPE_NAME visitPrintStmt(Print stmt);
  TYPE_NAME visitVarStmt(Var stmt);
}

abstract class Stmt<TYPE_NAME> {
  TYPE_NAME accept(StmtVisitor<TYPE_NAME> visitor);
}

class Block<TYPE_NAME> extends Stmt<TYPE_NAME> {
  Block(List<Stmt> statements) : 
    this.statements = statements
  {}

  TYPE_NAME accept(StmtVisitor<TYPE_NAME> visitor) {
    return visitor.visitBlockStmt(this);
  }

  List<Stmt> statements;
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

class Var<TYPE_NAME> extends Stmt<TYPE_NAME> {
  Var(Token name, Expr initializer) : 
    this.name = name,
    this.initializer = initializer
  {}

  TYPE_NAME accept(StmtVisitor<TYPE_NAME> visitor) {
    return visitor.visitVarStmt(this);
  }

  Token name;
  Expr initializer;
}

