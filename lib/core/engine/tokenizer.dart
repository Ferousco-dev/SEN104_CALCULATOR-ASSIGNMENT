import 'token.dart';

class TokenizerException implements Exception {
  const TokenizerException(this.message);
  final String message;
  @override
  String toString() => 'TokenizerException: $message';
}

abstract final class Tokenizer {
  static const _functions = {
    'sin', 'cos', 'tan', 'asin', 'acos', 'atan',
    'sinh', 'cosh', 'tanh', 'asinh', 'acosh', 'atanh',
    'ln', 'log', 'exp', 'sqrt', 'cbrt', 'abs', 'sign',
  };

  static const _constants = {'pi', 'e'};

  static List<Token> tokenize(String input) {
    final src = input.trim();
    final tokens = <Token>[];
    var i = 0;

    while (i < src.length) {
      final ch = src[i];

      if (ch == ' ') {
        i++;
        continue;
      }

      if (_isDigit(ch) || ch == '.') {
        final start = i;
        while (i < src.length && (_isDigit(src[i]) || src[i] == '.')) {
          i++;
        }
        tokens.add(Token(type: TokenType.number, value: src.substring(start, i)));
        continue;
      }

      if (_isLetter(ch)) {
        final start = i;
        while (i < src.length && _isAlphaNum(src[i])) {
          i++;
        }
        final word = src.substring(start, i);
        if (_functions.contains(word)) {
          tokens.add(Token(type: TokenType.function, value: word));
        } else if (_constants.contains(word)) {
          tokens.add(Token(type: TokenType.constant, value: word));
        } else {
          throw TokenizerException('Unknown identifier: $word');
        }
        continue;
      }

      switch (ch) {
        case '+':
          tokens.add(const Token(type: TokenType.plus, value: '+'));
        case '-':
          // Unary minus: at start, after operator, after left paren
          if (tokens.isEmpty ||
              tokens.last.isOperator ||
              tokens.last.type == TokenType.leftParen) {
            // Represent unary minus as a special function token
            tokens.add(const Token(type: TokenType.function, value: 'neg'));
          } else {
            tokens.add(const Token(type: TokenType.minus, value: '-'));
          }
        case '*' || 'x' || 'X':
          tokens.add(const Token(type: TokenType.multiply, value: '*'));
        case '/':
          tokens.add(const Token(type: TokenType.divide, value: '/'));
        case '^':
          tokens.add(const Token(type: TokenType.power, value: '^'));
        case '!':
          tokens.add(const Token(type: TokenType.factorial, value: '!'));
        case '(':
          tokens.add(const Token(type: TokenType.leftParen, value: '('));
        case ')':
          tokens.add(const Token(type: TokenType.rightParen, value: ')'));
        case ',':
          tokens.add(const Token(type: TokenType.comma, value: ','));
        case '×': // ×
          tokens.add(const Token(type: TokenType.multiply, value: '*'));
        case '÷': // ÷
          tokens.add(const Token(type: TokenType.divide, value: '/'));
        case '√': // √
          tokens.add(const Token(type: TokenType.function, value: 'sqrt'));
        case '∛': // ∛
          tokens.add(const Token(type: TokenType.function, value: 'cbrt'));
        case 'π': // π
          tokens.add(const Token(type: TokenType.constant, value: 'pi'));
        default:
          throw TokenizerException('Unexpected character: $ch');
      }
      i++;
    }

    return tokens;
  }

  static bool _isDigit(String ch) => ch.codeUnitAt(0) >= 48 && ch.codeUnitAt(0) <= 57;
  static bool _isLetter(String ch) {
    final c = ch.codeUnitAt(0);
    return (c >= 65 && c <= 90) || (c >= 97 && c <= 122);
  }
  static bool _isAlphaNum(String ch) => _isLetter(ch) || _isDigit(ch);
}
