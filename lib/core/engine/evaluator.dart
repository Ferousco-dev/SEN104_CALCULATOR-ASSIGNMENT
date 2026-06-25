import 'dart:math' as math;

import '../math/combinatorics.dart';
import '../math/hyperbolic.dart';
import '../math/scientific.dart';
import 'shunting_yard.dart';
import 'token.dart';
import 'tokenizer.dart';

class EvaluatorException implements Exception {
  const EvaluatorException(this.message);
  final String message;
  @override
  String toString() => 'EvaluatorException: $message';
}

enum AngleMode { degrees, radians }

abstract final class Evaluator {
  static double evaluate(String expression, {AngleMode angleMode = AngleMode.degrees}) {
    final tokens = Tokenizer.tokenize(expression);
    final rpn = ShuntingYard.convert(tokens);
    return _evalRpn(rpn, angleMode);
  }

  static double _evalRpn(List<Token> rpn, AngleMode mode) {
    final stack = <double>[];

    for (final token in rpn) {
      switch (token.type) {
        case TokenType.number:
          final v = double.tryParse(token.value);
          if (v == null) throw EvaluatorException('Malformed number: ${token.value}');
          stack.push(v);

        case TokenType.constant:
          switch (token.value) {
            case 'pi':
              stack.push(math.pi);
            case 'e':
              stack.push(math.e);
            default:
              throw EvaluatorException('Unknown constant: ${token.value}');
          }

        case TokenType.factorial:
          final a = stack.pop();
          if (a < 0 || a != a.truncateToDouble() || a > 170) {
            throw EvaluatorException('Factorial domain error: $a');
          }
          stack.push(Combinatorics.factorial(a.toInt()).toDouble());

        case TokenType.plus:
          final b = stack.pop();
          final a = stack.pop();
          stack.push(a + b);

        case TokenType.minus:
          final b = stack.pop();
          final a = stack.pop();
          stack.push(a - b);

        case TokenType.multiply:
          final b = stack.pop();
          final a = stack.pop();
          stack.push(a * b);

        case TokenType.divide:
          final b = stack.pop();
          final a = stack.pop();
          if (b == 0) throw const EvaluatorException('Division by zero');
          stack.push(a / b);

        case TokenType.power:
          final b = stack.pop();
          final a = stack.pop();
          stack.push(math.pow(a, b).toDouble());

        case TokenType.function:
          stack.push(_applyFunction(token.value, stack, mode));

        case TokenType.leftParen:
        case TokenType.rightParen:
        case TokenType.comma:
          break;
      }
    }

    if (stack.length != 1) {
      throw const EvaluatorException('Malformed expression');
    }
    final result = stack.pop();
    if (result.isNaN) throw const EvaluatorException('Result is not a number');
    if (result.isInfinite) throw const EvaluatorException('Result is infinite');
    return result;
  }

  static double _toRad(double value, AngleMode mode) =>
      mode == AngleMode.degrees ? value * math.pi / 180.0 : value;

  static double _fromRad(double value, AngleMode mode) =>
      mode == AngleMode.degrees ? value * 180.0 / math.pi : value;

  static double _applyFunction(String name, List<double> stack, AngleMode mode) {
    switch (name) {
      case 'neg':
        return -stack.pop();
      case 'sin':
        return Scientific.sin(_toRad(stack.pop(), mode));
      case 'cos':
        return Scientific.cos(_toRad(stack.pop(), mode));
      case 'tan':
        return Scientific.tan(_toRad(stack.pop(), mode));
      case 'asin':
        return _fromRad(Scientific.asin(stack.pop()), mode);
      case 'acos':
        return _fromRad(Scientific.acos(stack.pop()), mode);
      case 'atan':
        return _fromRad(Scientific.atan(stack.pop()), mode);
      case 'sinh':
        return Hyperbolic.sinh(stack.pop());
      case 'cosh':
        return Hyperbolic.cosh(stack.pop());
      case 'tanh':
        return Hyperbolic.tanh(stack.pop());
      case 'asinh':
        return Hyperbolic.asinh(stack.pop());
      case 'acosh':
        return Hyperbolic.acosh(stack.pop());
      case 'atanh':
        return Hyperbolic.atanh(stack.pop());
      case 'ln':
        return Scientific.ln(stack.pop());
      case 'log':
        // log with two arguments: log(base, x); one argument defaults to log10
        if (stack.length >= 2) {
          final x = stack.pop();
          final base = stack.pop();
          return Scientific.logBase(base, x);
        }
        return Scientific.log10(stack.pop());
      case 'exp':
        return Scientific.exp(stack.pop());
      case 'sqrt':
        return Scientific.sqrt(stack.pop());
      case 'cbrt':
        return Scientific.cbrt(stack.pop());
      case 'abs':
        return stack.pop().abs();
      case 'sign':
        final v = stack.pop();
        return v < 0 ? -1 : v > 0 ? 1 : 0;
      default:
        throw EvaluatorException('Unknown function: $name');
    }
  }
}

extension _StackOps on List<double> {
  void push(double v) => add(v);
  double pop() {
    if (isEmpty) throw const EvaluatorException('Expression stack underflow');
    return removeLast();
  }
}
