import 'package:flutter/foundation.dart';

import '../../core/engine/evaluator.dart';
import '../../core/format/number_format.dart';

class BasicState {
  const BasicState({
    this.expression = '',
    this.result = '',
    this.errorMessage,
  });

  final String expression;
  final String result;
  final String? errorMessage;

  BasicState copyWith({
    String? expression,
    String? result,
    String? errorMessage,
    bool clearError = false,
  }) {
    return BasicState(
      expression: expression ?? this.expression,
      result: result ?? this.result,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class BasicController extends ChangeNotifier {
  BasicState _state = const BasicState();
  BasicState get state => _state;

  String _input = '';

  void onKey(String key) {
    switch (key) {
      case 'AC':
        _input = '';
        _state = const BasicState();
      case 'C':
        if (_input.isNotEmpty) {
          _input = _input.substring(0, _input.length - 1);
          _evaluate();
        }
      case '=':
        _commitResult();
        return;
      case '+/-':
        if (_input.isNotEmpty) {
          if (_input.startsWith('-')) {
            _input = _input.substring(1);
          } else {
            _input = '-$_input';
          }
          _evaluate();
        }
      case '%':
        _appendAndEval('%');
      default:
        _appendAndEval(key);
    }
    notifyListeners();
  }

  void _appendAndEval(String token) {
    // Replace × and ÷ with operator symbols the engine understands
    final mapped = token
        .replaceAll('×', '*')
        .replaceAll('÷', '/');
    _input += mapped;
    _evaluate();
  }

  void _evaluate() {
    if (_input.isEmpty) {
      _state = const BasicState();
      return;
    }
    try {
      // Treat trailing operator as incomplete expression — show expression only
      final lastChar = _input[_input.length - 1];
      if ('+-*/'.contains(lastChar)) {
        _state = _state.copyWith(
          expression: _displayInput,
          result: '',
          clearError: true,
        );
        return;
      }
      final val = Evaluator.evaluate(_input);
      _state = BasicState(
        expression: _displayInput,
        result: NumberFormatter.format(val),
      );
    } catch (_) {
      _state = _state.copyWith(expression: _displayInput, result: '');
    }
  }

  void _commitResult() {
    if (_input.isEmpty) return;
    try {
      final val = Evaluator.evaluate(_input);
      final formatted = NumberFormatter.format(val);
      _input = formatted.replaceAll(',', '');
      _state = BasicState(result: formatted);
    } catch (e) {
      _state = BasicState(
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
    if (msg.contains('Malformed')) return 'Syntax error';
    return 'Error';
  }

  void restoreExpression(String expression) {
    _input = expression;
    _evaluate();
    notifyListeners();
  }

  String get expressionSnapshot => _input;
}
