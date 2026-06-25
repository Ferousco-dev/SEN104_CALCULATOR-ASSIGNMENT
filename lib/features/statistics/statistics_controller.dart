import 'package:flutter/foundation.dart';

import '../../core/format/number_format.dart';
import '../../core/math/statistics.dart';

class StatisticsState {
  const StatisticsState({
    this.input = '',
    this.result,
    this.errorMessage,
  });

  final String input;
  final StatResult? result;
  final String? errorMessage;

  StatisticsState copyWith({
    String? input,
    StatResult? result,
    String? errorMessage,
    bool clearResult = false,
    bool clearError = false,
  }) {
    return StatisticsState(
      input: input ?? this.input,
      result: clearResult ? null : result ?? this.result,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class StatisticsController extends ChangeNotifier {
  StatisticsState _state = const StatisticsState();
  StatisticsState get state => _state;

  void setInput(String value) {
    _state = _state.copyWith(input: value, clearError: true, clearResult: true);
    notifyListeners();
  }

  void compute() {
    try {
      final data = Statistics.parse(_state.input);
      final result = Statistics.compute(data);
      _state = _state.copyWith(result: result, clearError: true);
    } on StatisticsException catch (e) {
      _state = _state.copyWith(errorMessage: e.message, clearResult: true);
    }
    notifyListeners();
  }

  void clear() {
    _state = const StatisticsState();
    notifyListeners();
  }

  String _fmt(double v) => v.isNaN ? 'N/A' : NumberFormatter.format(v);

  String formatModes(List<double> modes) =>
      modes.isEmpty ? 'None' : modes.map(_fmt).join(', ');

  String fmtValue(double v) => _fmt(v);
}
