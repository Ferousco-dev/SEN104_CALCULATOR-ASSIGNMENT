import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:mycalculator/core/engine/evaluator.dart';

void main() {
  double eval(String expr, {AngleMode mode = AngleMode.degrees}) =>
      Evaluator.evaluate(expr, angleMode: mode);

  group('Evaluator — basic arithmetic', () {
    test('addition', () => expect(eval('1+2'), 3.0));
    test('subtraction', () => expect(eval('10-3'), 7.0));
    test('multiplication', () => expect(eval('4*5'), 20.0));
    test('division', () => expect(eval('10/4'), 2.5));
    test('chained precedence', () => expect(eval('2+3*4'), 14.0));
    test('parentheses override precedence', () => expect(eval('(2+3)*4'), 20.0));
    test('unary minus', () => expect(eval('-5'), -5.0));
    test('unary minus in expression', () => expect(eval('10+-3'), 7.0));
    test('power right-associativity', () => expect(eval('2^3^2'), 512.0));
    test('division by zero throws', () {
      expect(() => eval('1/0'), throwsA(isA<EvaluatorException>()));
    });
  });

  group('Evaluator — scientific (degrees)', () {
    test('sin(0)', () => expect(eval('sin(0)'), closeTo(0, 1e-10)));
    test('sin(90)', () => expect(eval('sin(90)'), closeTo(1, 1e-10)));
    test('cos(0)', () => expect(eval('cos(0)'), closeTo(1, 1e-10)));
    test('cos(180)', () => expect(eval('cos(180)'), closeTo(-1, 1e-10)));
    test('tan(45)', () => expect(eval('tan(45)'), closeTo(1, 1e-10)));
    test('ln(e)', () => expect(eval('ln(e)'), closeTo(1, 1e-10)));
    test('sqrt(16)', () => expect(eval('sqrt(16)'), closeTo(4, 1e-10)));
    test('cbrt(27)', () => expect(eval('cbrt(27)'), closeTo(3, 1e-10)));
  });

  group('Evaluator — scientific (radians)', () {
    test('sin(pi/2)', () {
      expect(eval('sin(pi/2)', mode: AngleMode.radians), closeTo(1, 1e-10));
    });
    test('cos(pi)', () {
      expect(eval('cos(pi)', mode: AngleMode.radians), closeTo(-1, 1e-10));
    });
    test('asin(1) in deg', () {
      expect(eval('asin(1)'), closeTo(90, 1e-8));
    });
    test('asin(1) in rad', () {
      expect(eval('asin(1)', mode: AngleMode.radians), closeTo(math.pi / 2, 1e-10));
    });
  });

  group('Evaluator — factorial', () {
    test('5!', () => expect(eval('5!'), 120.0));
    test('0!', () => expect(eval('0!'), 1.0));
  });

  group('Evaluator — constants', () {
    test('pi', () => expect(eval('pi'), closeTo(math.pi, 1e-12)));
    test('e', () => expect(eval('e'), closeTo(math.e, 1e-12)));
  });
}
