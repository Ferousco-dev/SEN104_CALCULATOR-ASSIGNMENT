import 'package:flutter/foundation.dart';

import '../../core/engine/evaluator.dart';
import '../../core/format/number_format.dart';

class ScientificState {
  const ScientificState({
    this.expression = '',
    this.result = '',
    this.errorMessage,
    this.angleMode = AngleMode.degrees,
    this.hypMode = false,
  });

  final String expression;
  final String result;
  final String? errorMessage;
  final AngleMode angleMode;
  final bool hypMode;

  ScientificState copyWith({
    String? expression,
    String? result,
    String? errorMessage,
    AngleMode? angleMode,
    bool? hypMode,
    bool clearError = false,
  }) {
    return ScientificState(
      expression: expression ?? this.expression,
      result: result ?? this.result,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      angleMode: angleMode ?? this.angleMode,
      hypMode: hypMode ?? this.hypMode,
    );
  }
}

class ScientificController extends ChangeNotifier {
  ScientificState _state = const ScientificState();
  ScientificState get state => _state;

  String _input = '';

  void onKey(String key) {
    switch (key) {
      case 'AC':
        _input = '';
        _state = ScientificState(
          angleMode: _state.angleMode,
          hypMode: _state.hypMode,
        );
      case 'C':
        if (_input.isNotEmpty) {
          _input = _input.substring(0, _input.length - 1);
          _evaluate();
        }
      case '=':
        _commitResult();
        return;
      case 'DEG':
        _state = _state.copyWith(angleMode: AngleMode.degrees);
      case 'RAD':
        _state = _state.copyWith(angleMode: AngleMode.radians);
      case 'HYP':
        _state = _state.copyWith(hypMode: !_state.hypMode);
      default:
        _appendAndEval(key);
    }
    notifyListeners();
  }

  void _appendAndEval(String token) {
    final mapped = token
        .replaceAll('×', '*')
        .replaceAll('÷', '/')
        .replaceAll('sqrt', 'sqrt(')
        .replaceAll('cbrt', 'cbrt(')
        .replaceAll('x!', '!')
        .replaceAll('x^y', '^')
        .replaceAll('pi', 'pi')
        .replaceAll('EXP', 'exp(');

    // Append function calls with opening paren if they end in (
    _input += mapped;
    _evaluate();
  }

  void _evaluate() {
    if (_input.isEmpty) {
      _state = _state.copyWith(expression: '', result: '', clearError: true);
      return;
    }
    try {
      final lastChar = _input[_input.length - 1];
      if ('+-*/^,('.contains(lastChar)) {
        _state = _state.copyWith(expression: _displayInput, result: '', clearError: true);
        return;
      }
      final val = Evaluator.evaluate(_input, angleMode: _state.angleMode);
      _state = _state.copyWith(
        expression: _displayInput,
        result: NumberFormatter.format(val),
        clearError: true,
      );
    } catch (_) {
      _state = _state.copyWith(expression: _displayInput, result: '');
    }
  }

  void _commitResult() {
    if (_input.isEmpty) return;
    try {
      final val = Evaluator.evaluate(_input, angleMode: _state.angleMode);
      final formatted = NumberFormatter.format(val);
      _input = formatted.replaceAll(',', '');
      _state = _state.copyWith(
        expression: '',
        result: formatted,
        clearError: true,
      );
    } catch (e) {
      _state = _state.copyWith(
        expression: _displayInput,
        errorMessage: _shortError(e),
      );
    }
    notifyListeners();
  }

  String get _displayInput => _input
      .replaceAll('*', '×')
      .replaceAll('/', '÷');

  String _shortError(Object e) {
    final msg = e.toString();
    if (msg.contains('Division by zero')) return 'Division by 0';
    if (msg.contains('domain')) return 'Domain error';
    if (msg.contains('undefined')) return 'Undefined';
    return 'Error';
  }

  void restoreExpression(String expression) {
    _input = expression;
    _evaluate();
    notifyListeners();
  }

  String get expressionSnapshot => _input;
}
