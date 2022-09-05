import 'dart:io';

import 'ASTPrinter.dart';
import 'Expr.dart';
import 'Interpreter.dart';
import 'Parser.dart';
import 'RuntimeError.dart';
import 'Scanner.dart';
import 'Token.dart';

void main(List<String> args) {
	Lox lox = Lox();

	if (args.length > 1) {
		print("Usage: jlox [script]");
		exit(64);
	} else if (args.length == 1) {
		lox.runFile(args[0]);
	} else {
		lox.runPrompt();
	}
}

class Lox {
  static Interpreter interpreter = new Interpreter();
	static bool hadError = false;
  static bool hadRuntimeError = false;

	void runFile(String path) {
		File(path).readAsString().then((String contents) {
			run(contents);
			if (hadError) exit(65);
		});
	}

	void runPrompt() {
	   for (;;) {
		 stdout.write("> ");
		 String? line = stdin.readLineSync();
		 if (line == null) break;
		 run(line);
		 hadError = false;
	   }
	}

	void run(String source) {
		Scanner scanner = new Scanner(source);
		List<Token> tokens = scanner.scanTokens();

		Parser parser = new Parser(tokens);
    Expr? expression = parser.parse();

    // Stop if there was a syntax error.
    if (hadError) return;

    if (expression != null) {
      interpreter.interpret(expression);
    }
	}

	static void errorCore(int line, String message) {
		report(line, "", message);
	}

	static void report(int line, String where, String message) {
		print("[line " + line.toString() + "] Error" + where + ": " + message);
		hadError = true;
	}

  static void error(Token token, String message) {
    if (token.type == TokenType.EOF) {
      report(token.line, " at end", message);
    } else {
      report(token.line, " at '" + token.lexeme + "'", message);
    }
  }

  static void runtimeError(RuntimeError error) {
    print(error.message + "\n[line " + error.token.line.toString() + "]");
    hadRuntimeError = true;
  }
}
