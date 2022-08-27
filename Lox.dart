import 'dart:io';
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
	static bool hadError = false;

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

		// For now, just print the tokens.
		tokens.forEach((token) => {
		  print(token)
		});
	}

	static void error(int line, String message) {
		report(line, "", message);
	}

	static void report(int line, String where, String message) {
		print("[line " + line.toString() + "] Error" + where + ": " + message);
		hadError = true;
	}
}
