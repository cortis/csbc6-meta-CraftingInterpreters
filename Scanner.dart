import 'Lox.dart';
import 'Token.dart';

class Scanner {
	String source = "";
	List<Token> tokens = [];
	int start = 0;
	int current = 0;
	int line = 1;
	Map<String, TokenType> keywords = {
		"and":TokenType.AND,
		"class":TokenType.CLASS,
		"else":TokenType.ELSE,
		"false":TokenType.FALSE,
		"for":TokenType.FOR,
		"fun":TokenType.FUN,
		"if":TokenType.IF,
		"nil":TokenType.NIL,
		"or":TokenType.OR,
		"print":TokenType.PRINT,
		"return":TokenType.RETURN,
		"super":TokenType.SUPER,
		"this":TokenType.THIS,
		"true":TokenType.TRUE,
		"var":TokenType.VAR,
		"while":TokenType.WHILE,
	};

	Scanner(String source) {
		this.source = source;
	}

	List<Token> scanTokens() {
		while (!isAtEnd()) {
      		// We are at the beginning of the next lexeme.
      		start = current;
      		scanToken();
    	}

    	tokens.add(Token(TokenType.EOF, "", null, line));
    	return tokens;
	}

	void scanToken() {
		String c = advance();
		switch (c) {
			case '(': addToken(TokenType.LEFT_PAREN); break;
			case ')': addToken(TokenType.RIGHT_PAREN); break;
			case '{': addToken(TokenType.LEFT_BRACE); break;
			case '}': addToken(TokenType.RIGHT_BRACE); break;
			case ',': addToken(TokenType.COMMA); break;
			case '.': addToken(TokenType.DOT); break;
			case '-': addToken(TokenType.MINUS); break;
			case '+': addToken(TokenType.PLUS); break;
			case ';': addToken(TokenType.SEMICOLON); break;
			case '*': addToken(TokenType.STAR); break;
			case '!':
				addToken(match('=') ? TokenType.BANG_EQUAL : TokenType.BANG);
				break;
			case '=':
        		addToken(match('=') ? TokenType.EQUAL_EQUAL : TokenType.EQUAL);
        		break;
      		case '<':
        		addToken(match('=') ? TokenType.LESS_EQUAL : TokenType.LESS);
        		break;
      		case '>':
        		addToken(match('=') ? TokenType.GREATER_EQUAL : TokenType.GREATER);
        		break;
			case '/':
        		if (match('/')) {
          			// A comment goes until the end of the line.
          			while (peek() != '\n' && !isAtEnd()) advance();
        		} else {
          			addToken(TokenType.SLASH);
        		}
        		break;
			  case ' ':
			case '\r':
			case '\t':
				// Ignore whitespace.
				break;
			case '\n':
				line++;
				break;
			case '"': string(); break;
			default:
			if (isDigit(c)) {
				number();
			} else if (isAlpha(c)) {
          		identifier();
        	} else {
				Lox.errorCore(line, "Unexpected character '" + c + "'.");
			}
			break;
		}
	}

	bool isAtEnd() {
    	return (current >= source.length);
  	}

	bool isDigit(String c) {
		int charC = c.codeUnitAt(0);
		return (charC >= '0'.codeUnitAt(0) && charC <= '9'.codeUnitAt(0));
	}

	bool isAlpha(String c) {
		int charC = c.codeUnitAt(0);
		return ((charC >= 'a'.codeUnitAt(0) && charC <= 'z'.codeUnitAt(0)) ||
				(charC >= 'A'.codeUnitAt(0) && charC <= 'Z'.codeUnitAt(0)) ||
				 charC == '_'.codeUnitAt(0));
	}

	bool isAlphaNumeric(String c) {
		return isAlpha(c) || isDigit(c);
	}

	bool match(String expected) {
		if (isAtEnd()) return false;
		if (source[current] != expected) return false;

		current++;
		return true;
	}

	String peek() {
		if (isAtEnd()) return '\n';
		return source[current];
	}

	String peekNext() {
		if (current + 1 >= source.length) return '\0';
		return source[current + 1];
	}

	void identifier() {
    	while (isAlphaNumeric(peek())) advance();

		String text = source.substring(start, current);
		TokenType? type = keywords[text];
		if (type == null) type = TokenType.IDENTIFIER;
		addToken(type);
  	}

	void number() {
    	while (isDigit(peek())) advance();

    	// Look for a fractional part.
		if (peek() == '.' && isDigit(peekNext())) {
			// Consume the "."
			advance();

			while (isDigit(peek())) advance();
		}

		addTokenCore(TokenType.NUMBER, double.parse(source.substring(start, current)));
	}

	void string() {
		while (peek() != '"' && !isAtEnd()) {
			if (peek() == '\n') line++;
			advance();
		}

		if (isAtEnd()) {
			Lox.errorCore(line, "Unterminated string.");
			return;
		}

		// The closing ".
		advance();

		// Trim the surrounding quotes.
		String value = source.substring(start + 1, current - 1);
		addTokenCore(TokenType.STRING, value);
	}

	String advance() {
    	return source[current++];
	}

	void addToken(TokenType type) {
  		addTokenCore(type, null);
  	}

	void addTokenCore(TokenType type, Object? literal) {
		String text = source.substring(start, current);
		tokens.add(Token(type, text, literal, line));
  	}
}
