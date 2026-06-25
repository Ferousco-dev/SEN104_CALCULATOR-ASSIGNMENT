import 'package:flutter_test/flutter_test.dart';
import 'package:mycalculator/core/math/matrix.dart';

Matrix m2(List<List<double>> v) => Matrix.fromList(2, 2, v);
Matrix m3(List<List<double>> v) => Matrix.fromList(3, 3, v);

void main() {
  group('Matrix — basic ops', () {
    test('addition', () {
      final a = m2([[1, 2], [3, 4]]);
      final b = m2([[5, 6], [7, 8]]);
      final c = a + b;
      expect(c.get(0, 0), 6);
      expect(c.get(1, 1), 12);
    });

    test('subtraction', () {
      final a = m2([[5, 6], [7, 8]]);
      final b = m2([[1, 2], [3, 4]]);
      final c = a - b;
      expect(c.get(0, 0), 4);
      expect(c.get(1, 1), 4);
    });

    test('scalar multiplication', () {
      final a = m2([[1, 2], [3, 4]]);
      final b = a * 2.0;
      expect(b.get(0, 0), 2);
      expect(b.get(1, 1), 8);
    });

    test('matrix multiplication', () {
      final a = m2([[1, 2], [3, 4]]);
      final b = m2([[2, 0], [1, 2]]);
      final c = a * b;
      expect(c.get(0, 0), 4);
      expect(c.get(0, 1), 4);
      expect(c.get(1, 0), 10);
      expect(c.get(1, 1), 8);
    });

    test('transpose', () {
      final a = m2([[1, 2], [3, 4]]);
      final t = a.transpose;
      expect(t.get(0, 1), 3);
      expect(t.get(1, 0), 2);
    });

    test('dimension mismatch throws', () {
      final a = m2([[1, 2], [3, 4]]);
      final b = m3([[1, 0, 0], [0, 1, 0], [0, 0, 1]]);
      expect(() => a + b, throwsA(isA<MatrixException>()));
    });
  });

  group('Matrix — determinant', () {
    test('2x2 det', () {
      final a = m2([[3, 8], [4, 6]]);
      expect(a.determinant, closeTo(-14, 1e-10));
    });

    test('3x3 det', () {
      final a = m3([[6, 1, 1], [4, -2, 5], [2, 8, 7]]);
      expect(a.determinant, closeTo(-306, 1e-8));
    });

    test('identity det is 1', () {
      expect(Matrix.identity(3).determinant, closeTo(1, 1e-10));
    });
  });

  group('Matrix — inverse', () {
    test('2x2 inverse', () {
      final a = m2([[4, 7], [2, 6]]);
      final inv = a.inverse;
      final prod = a * inv;
      for (var i = 0; i < 2; i++) {
        for (var j = 0; j < 2; j++) {
          expect(prod.get(i, j), closeTo(i == j ? 1 : 0, 1e-10));
        }
      }
    });

    test('singular matrix throws', () {
      final a = m2([[1, 2], [2, 4]]);
      expect(() => a.inverse, throwsA(isA<MatrixException>()));
    });
  });
}
