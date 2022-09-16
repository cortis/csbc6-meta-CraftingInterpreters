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
  Block(this.statements);

  TYPE_NAME accept(StmtVisitor<TYPE_NAME> visitor) {
    return visitor.visitBlockStmt(this);
  }

  List<Stmt> statements;
}

class Expression<TYPE_NAME> extends Stmt<TYPE_NAME> {
  Expression(this.expression);

  TYPE_NAME accept(StmtVisitor<TYPE_NAME> visitor) {
    return visitor.visitExpressionStmt(this);
  }

  Expr expression;
}

class If<TYPE_NAME> extends Stmt<TYPE_NAME> {
  If(this.condition, this.thenBranch, this.elseBranch);

  TYPE_NAME accept(StmtVisitor<TYPE_NAME> visitor) {
    return visitor.visitIfStmt(this);
  }

  Expr condition;
  Stmt thenBranch;
  Stmt? elseBranch;
}

class Print<TYPE_NAME> extends Stmt<TYPE_NAME> {
  Print(this.expression);

  TYPE_NAME accept(StmtVisitor<TYPE_NAME> visitor) {
    return visitor.visitPrintStmt(this);
  }

  Expr expression;
}

class Var<TYPE_NAME> extends Stmt<TYPE_NAME> {
  Var(this.name, this.initializer);

  TYPE_NAME accept(StmtVisitor<TYPE_NAME> visitor) {
    return visitor.visitVarStmt(this);
  }

  Token name;
  Expr initializer;
}

class While<TYPE_NAME> extends Stmt<TYPE_NAME> {
  While(this.condition, this.body);

  TYPE_NAME accept(StmtVisitor<TYPE_NAME> visitor) {
    return visitor.visitWhileStmt(this);
  }

  Expr condition;
  Stmt body;
}

