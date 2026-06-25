import 'token.dart';

class ShuntingYardException implements Exception {
  const ShuntingYardException(this.message);
  final String message;
  @override
  String toString() => 'ShuntingYardException: $message';
}

// Converts an infix token list to Reverse Polish Notation (RPN).
//
// Precedence table:
//   + -   -> 1  (left-associative)
//   * /   -> 2  (left-associative)
//   ^     -> 3  (right-associative — x^y^z = x^(y^z))
//   unary -> 4  (right-associative, higher than binary)
//   !     -> 5  (post-fix, handled as right-pop)
abstract final class ShuntingYard {
  static int _precedence(Token t) {
    switch (t.type) {
      case TokenType.plus:
      case TokenType.minus:
        return 1;
      case TokenType.multiply:
      case TokenType.divide:
        return 2;
      case TokenType.power:
        return 3;
      default:
        return 0;
    }
  }

  static bool _isRightAssociative(Token t) => t.type == TokenType.power;

  static List<Token> convert(List<Token> tokens) {
    final output = <Token>[];
    final stack = <Token>[];

    for (final token in tokens) {
      switch (token.type) {
        case TokenType.number:
        case TokenType.constant:
          output.add(token);

        case TokenType.function:
          // 'neg' (unary minus) is a right-associative prefix function
          stack.add(token);

        case TokenType.comma:
          // Pop until left paren (separates function arguments)
          while (stack.isNotEmpty && stack.last.type != TokenType.leftParen) {
            output.add(stack.removeLast());
          }
          if (stack.isEmpty) {
            throw const ShuntingYardException('Mismatched parentheses or comma outside function');
          }

        case TokenType.factorial:
          // Post-fix operator — emit immediately, no need to push
          output.add(token);

        case TokenType.plus:
        case TokenType.minus:
        case TokenType.multiply:
        case TokenType.divide:
        case TokenType.power:
          while (stack.isNotEmpty) {
            final top = stack.last;
            if (top.type == TokenType.leftParen || top.isFunction) break;
            final topPrec = _precedence(top);
            final curPrec = _precedence(token);
            if (topPrec > curPrec || (topPrec == curPrec && !_isRightAssociative(token))) {
              output.add(stack.removeLast());
            } else {
              break;
            }
          }
          stack.add(token);

        case TokenType.leftParen:
          stack.add(token);

        case TokenType.rightParen:
          while (stack.isNotEmpty && stack.last.type != TokenType.leftParen) {
            output.add(stack.removeLast());
          }
          if (stack.isEmpty) {
            throw const ShuntingYardException('Mismatched parentheses: unexpected )');
          }
          stack.removeLast(); // discard left paren
          // If a function token sits on top, pop it into output
          if (stack.isNotEmpty && stack.last.isFunction) {
            output.add(stack.removeLast());
          }
      }
    }

    while (stack.isNotEmpty) {
      final top = stack.removeLast();
      if (top.type == TokenType.leftParen) {
        throw const ShuntingYardException('Mismatched parentheses: unclosed (');
      }
      output.add(top);
    }

    return output;
  }
}
