enum TokenType {
  number,
  plus,
  minus,
  multiply,
  divide,
  power,
  factorial,
  leftParen,
  rightParen,
  comma,
  function,
  constant,
}

class Token {
  const Token({required this.type, required this.value});

  final TokenType type;
  final String value;

  bool get isOperator => type == TokenType.plus ||
      type == TokenType.minus ||
      type == TokenType.multiply ||
      type == TokenType.divide ||
      type == TokenType.power;

  bool get isNumber => type == TokenType.number;
  bool get isFunction => type == TokenType.function;
  bool get isConstant => type == TokenType.constant;

  @override
  String toString() => 'Token($type, $value)';
}
