import 'dart:collection';

import 'RuntimeError.dart';
import 'Token.dart';

class Environment {
  final Map<String, Object> values = new HashMap();

  void define(String name, Object value) {
    values[name] = value;
  }

  Object get(Token name) {
    if (values.containsKey(name.lexeme)) {
      // Note: we already ensured that values contains name.lexeme so we shouldn't ever see this defaulting to 0
      return values[name.lexeme] ?? 0;
    }

    throw new RuntimeError(name, "Undefined variable '" + name.lexeme + "'.");
  }

  void assign(Token name, Object value) {
    if (values.containsKey(name.lexeme)) {
      values[name.lexeme] = value;
      return;
    }

    throw new RuntimeError(name, "Undefined variable '" + name.lexeme + "'.");
  }
}
