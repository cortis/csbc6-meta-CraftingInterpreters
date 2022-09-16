import 'Expr.dart';
import 'Token.dart';

abstract class StmtVisitor<TYPE_NAME> {
  TYPE_NAME visitBlockStmt(Block stmt);
  TYPE_NAME visitExpressionStmt(Expression stmt);
  TYPE_NAME visitIfStmt(If stmt);
  TYPE_NAME visitPrintStmt(Print stmt);
  TYPE_NAME visitVarStmt(Var stmt);
  TYPE_NAME visitWhileStmt(While stmt);
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

class If<TYPE_NAME> extends Stmt<TYPE_NAME> {
  If(Expr condition, Stmt thenBranch, Stmt? elseBranch) : 
    this.condition = condition,
    this.thenBranch = thenBranch,
    this.elseBranch = elseBranch
  {}

  TYPE_NAME accept(StmtVisitor<TYPE_NAME> visitor) {
    return visitor.visitIfStmt(this);
  }

  Expr condition;
  Stmt thenBranch;
  Stmt? elseBranch;
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

class While<TYPE_NAME> extends Stmt<TYPE_NAME> {
  While(Expr condition, Stmt body) : 
    this.condition = condition,
    this.body = body
  {}

  TYPE_NAME accept(StmtVisitor<TYPE_NAME> visitor) {
    return visitor.visitWhileStmt(this);
  }

  Expr condition;
  Stmt body;
}

