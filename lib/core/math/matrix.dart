class MatrixException implements Exception {
  const MatrixException(this.message);
  final String message;
  @override
  String toString() => 'MatrixException: $message';
}

class Matrix {
  Matrix(this.rows, this.cols, this._data) {
    assert(_data.length == rows * cols);
  }

  factory Matrix.zero(int rows, int cols) =>
      Matrix(rows, cols, List.filled(rows * cols, 0.0));

  factory Matrix.identity(int size) {
    final data = List.filled(size * size, 0.0);
    for (var i = 0; i < size; i++) {
      data[i * size + i] = 1.0;
    }
    return Matrix(size, size, data);
  }

  factory Matrix.fromList(int rows, int cols, List<List<double>> values) {
    if (values.length != rows) throw const MatrixException('Row count mismatch');
    final data = <double>[];
    for (final row in values) {
      if (row.length != cols) throw const MatrixException('Column count mismatch');
      data.addAll(row);
    }
    return Matrix(rows, cols, data);
  }

  final int rows;
  final int cols;
  final List<double> _data;

  double get(int r, int c) => _data[r * cols + c];
  void set(int r, int c, double v) => _data[r * cols + c] = v;

  bool get isSquare => rows == cols;

  List<List<double>> toList() {
    return List.generate(rows, (r) => List.generate(cols, (c) => get(r, c)));
  }

  Matrix operator +(Matrix other) {
    _checkSameDimensions(other);
    return Matrix(rows, cols, List.generate(rows * cols, (i) => _data[i] + other._data[i]));
  }

  Matrix operator -(Matrix other) {
    _checkSameDimensions(other);
    return Matrix(rows, cols, List.generate(rows * cols, (i) => _data[i] - other._data[i]));
  }

  Matrix operator *(Object other) {
    if (other is double || other is int) {
      final s = (other is int) ? other.toDouble() : other as double;
      return Matrix(rows, cols, _data.map((v) => v * s).toList());
    }
    if (other is Matrix) {
      if (cols != other.rows) {
        throw MatrixException('Dimension mismatch: ${rows}x$cols * ${other.rows}x${other.cols}');
      }
      final result = Matrix.zero(rows, other.cols);
      for (var r = 0; r < rows; r++) {
        for (var c = 0; c < other.cols; c++) {
          double sum = 0;
          for (var k = 0; k < cols; k++) {
            sum += get(r, k) * other.get(k, c);
          }
          result.set(r, c, sum);
        }
      }
      return result;
    }
    throw MatrixException('Cannot multiply matrix by ${other.runtimeType}');
  }

  Matrix get transpose {
    final result = Matrix.zero(cols, rows);
    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols; c++) {
        result.set(c, r, get(r, c));
      }
    }
    return result;
  }

  double get determinant {
    if (!isSquare) throw const MatrixException('Determinant requires a square matrix');
    return _det(_dataCopy(), rows);
  }

  // Gaussian elimination with partial pivoting to compute the inverse.
  Matrix get inverse {
    if (!isSquare) throw const MatrixException('Inverse requires a square matrix');
    final n = rows;
    final aug = List.generate(n, (r) => List.generate(2 * n, (c) {
      if (c < n) return get(r, c);
      return c - n == r ? 1.0 : 0.0;
    }));

    for (var col = 0; col < n; col++) {
      // Partial pivot
      var maxRow = col;
      for (var r = col + 1; r < n; r++) {
        if (aug[r][col].abs() > aug[maxRow][col].abs()) maxRow = r;
      }
      final tmp = aug[col];
      aug[col] = aug[maxRow];
      aug[maxRow] = tmp;

      if (aug[col][col].abs() < 1e-12) {
        throw const MatrixException('Matrix is singular — inverse does not exist');
      }
      final pivot = aug[col][col];
      for (var j = 0; j < 2 * n; j++) {
        aug[col][j] /= pivot;
      }
      for (var r = 0; r < n; r++) {
        if (r == col) continue;
        final factor = aug[r][col];
        for (var j = 0; j < 2 * n; j++) {
          aug[r][j] -= factor * aug[col][j];
        }
      }
    }

    return Matrix.fromList(n, n, List.generate(n, (r) => List.generate(n, (c) => aug[r][n + c])));
  }

  // Recursive Leibniz / cofactor expansion; only used for n <= 4
  static double _det(List<double> data, int n) {
    if (n == 1) return data[0];
    if (n == 2) return data[0] * data[3] - data[1] * data[2];
    double det = 0;
    for (var col = 0; col < n; col++) {
      final minor = _minor(data, n, 0, col);
      final sign = col.isEven ? 1.0 : -1.0;
      det += sign * data[col] * _det(minor, n - 1);
    }
    return det;
  }

  static List<double> _minor(List<double> data, int n, int skipRow, int skipCol) {
    final result = <double>[];
    for (var r = 0; r < n; r++) {
      if (r == skipRow) continue;
      for (var c = 0; c < n; c++) {
        if (c == skipCol) continue;
        result.add(data[r * n + c]);
      }
    }
    return result;
  }

  List<double> _dataCopy() => List.of(_data);

  void _checkSameDimensions(Matrix other) {
    if (rows != other.rows || cols != other.cols) {
      throw MatrixException('Dimension mismatch: ${rows}x$cols vs ${other.rows}x${other.cols}');
    }
  }
}
