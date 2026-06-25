import 'package:flutter/foundation.dart';

import '../../core/format/number_format.dart';
import '../../core/math/matrix.dart';

enum MatrixOp { add, subtract, multiply, scalarMultiply, determinant, inverse, transpose }

class MatrixState {
  const MatrixState({
    this.size = 2,
    required this.matrixA,
    required this.matrixB,
    this.resultRows,
    this.resultLabel = '',
    this.errorMessage,
  });

  final int size;
  final List<List<String>> matrixA;
  final List<List<String>> matrixB;
  final List<List<String>>? resultRows;
  final String resultLabel;
  final String? errorMessage;

  static MatrixState initial(int size) => MatrixState(
    size: size,
    matrixA: List.generate(size, (_) => List.filled(size, '0')),
    matrixB: List.generate(size, (_) => List.filled(size, '0')),
  );

  MatrixState copyWith({
    int? size,
    List<List<String>>? matrixA,
    List<List<String>>? matrixB,
    List<List<String>>? resultRows,
    String? resultLabel,
    String? errorMessage,
    bool clearResult = false,
    bool clearError = false,
  }) {
    return MatrixState(
      size: size ?? this.size,
      matrixA: matrixA ?? this.matrixA,
      matrixB: matrixB ?? this.matrixB,
      resultRows: clearResult ? null : resultRows ?? this.resultRows,
      resultLabel: resultLabel ?? this.resultLabel,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class MatrixController extends ChangeNotifier {
  MatrixState _state = MatrixState.initial(2);
  MatrixState get state => _state;

  void setSize(int size) {
    _state = MatrixState.initial(size);
    notifyListeners();
  }

  void setCellA(int r, int c, String value) {
    final updated = _copyMatrix(_state.matrixA);
    updated[r][c] = value;
    _state = _state.copyWith(matrixA: updated, clearError: true);
    notifyListeners();
  }

  void setCellB(int r, int c, String value) {
    final updated = _copyMatrix(_state.matrixB);
    updated[r][c] = value;
    _state = _state.copyWith(matrixB: updated, clearError: true);
    notifyListeners();
  }

  void compute(MatrixOp op) {
    try {
      final a = _parse(_state.matrixA);
      switch (op) {
        case MatrixOp.add:
          _setResult(a + _parse(_state.matrixB), 'A + B');
        case MatrixOp.subtract:
          _setResult(a - _parse(_state.matrixB), 'A - B');
        case MatrixOp.multiply:
          _setResult(a * _parse(_state.matrixB), 'A x B');
        case MatrixOp.scalarMultiply:
          final scalar = double.parse(_state.matrixB[0][0]);
          _setResult(a * scalar, 'scalar x A');
        case MatrixOp.transpose:
          _setResult(a.transpose, 'A^T');
        case MatrixOp.determinant:
          final det = a.determinant;
          _state = _state.copyWith(
            resultRows: [[NumberFormatter.format(det)]],
            resultLabel: 'det(A)',
            clearError: true,
          );
        case MatrixOp.inverse:
          _setResult(a.inverse, 'A^-1');
      }
    } on MatrixException catch (e) {
      _state = _state.copyWith(
        errorMessage: e.message,
        clearResult: true,
      );
    } catch (e) {
      _state = _state.copyWith(
        errorMessage: 'Input error: check all cells contain numbers',
        clearResult: true,
      );
    }
    notifyListeners();
  }

  void clear() {
    _state = MatrixState.initial(_state.size);
    notifyListeners();
  }

  void _setResult(Matrix m, String label) {
    _state = _state.copyWith(
      resultRows: m.toList().map((row) => row.map(NumberFormatter.format).toList()).toList(),
      resultLabel: label,
      clearError: true,
    );
  }

  Matrix _parse(List<List<String>> cells) {
    final n = cells.length;
    return Matrix.fromList(
      n,
      n,
      cells.map((row) => row.map((v) {
        final parsed = double.tryParse(v.isEmpty ? '0' : v);
        if (parsed == null) throw FormatException('Invalid cell value: $v');
        return parsed;
      }).toList()).toList(),
    );
  }

  List<List<String>> _copyMatrix(List<List<String>> m) =>
      m.map((row) => List<String>.of(row)).toList();
}
