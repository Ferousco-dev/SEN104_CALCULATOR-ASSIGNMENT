import 'package:flutter/foundation.dart';

import '../../core/format/number_format.dart';
import '../../core/math/combinatorics.dart';

class CombinatoryResult {
  const CombinatoryResult({
    required this.nPr,
    required this.nCr,
    required this.nFactorial,
  });

  final String nPr;
  final String nCr;
  final String nFactorial;
}

class CombinatoricsState {
  const CombinatoricsState({
    this.nInput = '',
    this.rInput = '',
    this.result,
    this.errorMessage,
  });

  final String nInput;
  final String rInput;
  final CombinatoryResult? result;
  final String? errorMessage;

  CombinatoricsState copyWith({
    String? nInput,
    String? rInput,
    CombinatoryResult? result,
    String? errorMessage,
    bool clearResult = false,
    bool clearError = false,
  }) {
    return CombinatoricsState(
      nInput: nInput ?? this.nInput,
      rInput: rInput ?? this.rInput,
      result: clearResult ? null : result ?? this.result,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class CombinatoricsController extends ChangeNotifier {
  CombinatoricsState _state = const CombinatoricsState();
  CombinatoricsState get state => _state;

  void setN(String value) {
    _state = _state.copyWith(nInput: value, clearError: true);
    notifyListeners();
  }

  void setR(String value) {
    _state = _state.copyWith(rInput: value, clearError: true);
    notifyListeners();
  }

  void compute() {
    final n = int.tryParse(_state.nInput.trim());
    final r = int.tryParse(_state.rInput.trim());

    if (n == null) {
      _state = _state.copyWith(errorMessage: 'n must be a non-negative integer');
      notifyListeners();
      return;
    }

    try {
      final factN = Combinatorics.factorial(n);
      final pNr = r != null ? Combinatorics.nPr(n, r) : null;
      final cNr = r != null ? Combinatorics.nCr(n, r) : null;

      _state = _state.copyWith(
        result: CombinatoryResult(
          nPr: pNr != null ? NumberFormatter.formatBigInt(pNr) : 'Enter r',
          nCr: cNr != null ? NumberFormatter.formatBigInt(cNr) : 'Enter r',
          nFactorial: NumberFormatter.formatBigInt(factN),
        ),
        clearError: true,
      );
    } on CombinatoricsException catch (e) {
      _state = _state.copyWith(errorMessage: e.message, clearResult: true);
    }
    notifyListeners();
  }

  void clear() {
    _state = const CombinatoricsState();
    notifyListeners();
  }
}
