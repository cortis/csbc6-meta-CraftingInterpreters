import 'Token.dart';

class RuntimeError implements Exception {
  Token token;
  String message;

  RuntimeError(Token token, String message) :
    this.token = token,
    this.message = message
  {}
}
