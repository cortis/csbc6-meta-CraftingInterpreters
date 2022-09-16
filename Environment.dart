import 'dart:collection';

import 'RuntimeError.dart';
import 'Token.dart';

class Environment {
  final Environment? enclosing;
  final Map<String, Object> values = new HashMap();

  Environment.empty() : enclosing = null {}

  Environment(this.enclosing);

  void define(String name, Object value) {
    values[name] = value;
  }

  Object get(Token name) {
    if (values.containsKey(name.lexeme)) {
      // Note: we already ensured that values contains name.lexeme so we shouldn't ever see this defaulting to 0
      return values[name.lexeme] ?? 0;
    }

    if (enclosing != null) {
      return enclosing!.get(name);
    }

    throw new RuntimeError(name, "Undefined variable '" + name.lexeme + "'.");
  }

  void assign(Token name, Object value) {
    if (values.containsKey(name.lexeme)) {
      values[name.lexeme] = value;
      return;
    }

    if (enclosing != null) {
      enclosing!.assign(name, value);
      return;
    }

    throw new RuntimeError(name, "Undefined variable '" + name.lexeme + "'.");
  }
}
