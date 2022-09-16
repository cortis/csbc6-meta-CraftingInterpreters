import 'Expr.dart';
import 'Lox.dart';
import 'RuntimeError.dart';
import 'Stmt.dart';
import 'Token.dart';

class Parser {
  List<Token> tokens;
  int current = 0;

  Parser(List<Token> tokens) : this.tokens = tokens {}

  List<Stmt> parse() {
    List<Stmt> statements = [];
    while (!isAtEnd()) {
      Stmt? decl = declaration();
      if (decl != null) {
        statements.add(decl);
      } else {
        break;
      }
    }

    return statements;
  }

  Expr expression() {
    return assignment();
  }

  Stmt? declaration() {
    try {
      if (match([TokenType.VAR])) return varDeclaration();

      return statement();
    } catch (error) {
      //synchronize();
      return null;
    }
  }

  Stmt statement() {
    if (match([TokenType.PRINT])) return printStatement();
    if (match([TokenType.IF])) return ifStatement();
    if (match([TokenType.WHILE])) return whileStatement();
    if (match([TokenType.LEFT_BRACE])) return Block(block());

    return expressionStatement();
  }

  Stmt ifStatement() {
    consume(TokenType.LEFT_PAREN, "Expect '(' after 'if'.");
    Expr condition = expression();
    consume(TokenType.RIGHT_PAREN, "Expect ')' after if condition."); 

    Stmt thenBranch = statement();
    Stmt? elseBranch = null;
    if (match([TokenType.ELSE])) {
      elseBranch = statement();
    }

    return new If(condition, thenBranch, elseBranch);
  }

  Stmt printStatement() {
    Expr value = expression();
    consume(TokenType.SEMICOLON, "Expect ';' after value.");
    return new Print(value);
  }

  Stmt varDeclaration() {
    Token name = consume(TokenType.IDENTIFIER, "Expect a variable name.");

    if (match([TokenType.EQUAL])) {
      Expr initializer = expression();

      consume(TokenType.SEMICOLON, "Expect ';' after variable declaration.");
      return new Var(name, initializer);
    }

    throw new RuntimeError(name, "All variables must be initialized.");
  }

  Stmt whileStatement() {
    consume(TokenType.LEFT_PAREN, "Expect '(' after 'while'.");
    Expr condition = expression();
    consume(TokenType.RIGHT_PAREN, "Expect ')' after condition.");
    Stmt body = statement();

    return new While(condition, body);
  }

  Stmt expressionStatement() {
    Expr expr = expression();
    consume(TokenType.SEMICOLON, "Expect ';' after expression.");
    return new Expression(expr);
  }

  List<Stmt> block() {
    List<Stmt> statements = [];

    while (!check(TokenType.RIGHT_BRACE) && !isAtEnd()) {
      var decl = declaration();
      if (decl != null) {
        statements.add(decl);
      }
    }

    consume(TokenType.RIGHT_BRACE, "Expect '}' after block.");
    return statements;
  }

  Expr assignment() {
    Expr expr = or();

    if (match([TokenType.EQUAL])) {
      Token equals = previous();
      Expr value = assignment();

      if (expr is Variable) {
        Token name = expr.name;
        return new Assign(name, value);
      }

      error(equals, "Invalid assignment target.");
    }

    return expr;
  }

  Expr or() {
    Expr expr = and();

    while (match([TokenType.OR])) {
      Token operator = previous();
      Expr right = and();
      expr = new Logical(expr, operator, right);
    }

    return expr;
  }

  Expr and() {
    Expr expr = equality();

    while (match([TokenType.AND])) {
      Token operator = previous();
      Expr right = equality();
      expr = new Logical(expr, operator, right);
    }

    return expr;
  }

  Expr equality() {
    Expr expr = comparison();

    while (match([TokenType.BANG_EQUAL, TokenType.EQUAL_EQUAL])) {
      Token operator = previous();
      Expr right = comparison();
      expr = new Binary(expr, operator, right);
    }

    return expr;
  }

  Expr comparison() {
    Expr expr = term();

    while (match([
      TokenType.GREATER,
      TokenType.GREATER_EQUAL,
      TokenType.LESS,
      TokenType.LESS_EQUAL
    ])) {
      Token operator = previous();
      Expr right = term();
      expr = new Binary(expr, operator, right);
    }

    return expr;
  }

  Expr term() {
    Expr expr = factor();

    while (match([TokenType.MINUS, TokenType.PLUS])) {
      Token operator = previous();
      Expr right = factor();
      expr = new Binary(expr, operator, right);
    }

    return expr;
  }

  Expr factor() {
    Expr expr = unary();

    while (match([TokenType.SLASH, TokenType.STAR])) {
      Token operator = previous();
      Expr right = unary();
      expr = new Binary(expr, operator, right);
    }

    return expr;
  }

  Expr unary() {
    if (match([TokenType.BANG, TokenType.MINUS])) {
      Token operator = previous();
      Expr right = unary();
      return new Unary(operator, right);
    }

    return primary();
  }

  Expr primary() {
    if (match([TokenType.FALSE])) return new Literal(false);
    if (match([TokenType.TRUE])) return new Literal(true);
    if (match([TokenType.NIL])) return new Literal(null);

    if (match([TokenType.NUMBER, TokenType.STRING])) {
      return new Literal(previous().literal);
    }

    if (match([TokenType.IDENTIFIER])) {
      return new Variable(previous());
    }

    if (match([TokenType.LEFT_PAREN])) {
      Expr expr = expression();
      consume(TokenType.RIGHT_PAREN, "Expect ')' after expression.");
      return new Grouping(expr);
    }

    throw error(peek(), "Expect expression.");
  }

  bool match(List<TokenType> types) {
    for (TokenType type in types) {
      if (check(type)) {
        advance();
        return true;
      }
    }

    return false;
  }

  Token consume(TokenType type, String message) {
    if (check(type)) return advance();

    throw error(peek(), message);
  }

  bool check(TokenType type) {
    if (isAtEnd()) return false;
    return peek().type == type;
  }

  Token advance() {
    if (!isAtEnd()) current++;
    return previous();
  }

  bool isAtEnd() {
    return peek().type == TokenType.EOF;
  }

  Token peek() {
    return tokens[current];
  }

  Token previous() {
    return tokens[current - 1];
  }

  ParseError error(Token token, String message) {
    Lox.error(token, message);
    return new ParseError();
  }
}

class ParseError {} //extends RuntimeException {}
