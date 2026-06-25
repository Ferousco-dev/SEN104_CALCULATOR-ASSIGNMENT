import 'package:flutter_test/flutter_test.dart';
import 'package:mycalculator/core/math/combinatorics.dart';

void main() {
  group('Combinatorics — factorial', () {
    test('0! = 1', () => expect(Combinatorics.factorial(0), BigInt.one));
    test('1! = 1', () => expect(Combinatorics.factorial(1), BigInt.one));
    test('5! = 120', () => expect(Combinatorics.factorial(5), BigInt.from(120)));
    test('10! = 3628800', () => expect(Combinatorics.factorial(10), BigInt.from(3628800)));
    test('20! is exact', () => expect(Combinatorics.factorial(20), BigInt.parse('2432902008176640000')));
    test('negative throws', () => expect(() => Combinatorics.factorial(-1), throwsA(isA<CombinatoricsException>())));
  });

  group('Combinatorics — nPr', () {
    test('P(5,2) = 20', () => expect(Combinatorics.nPr(5, 2), BigInt.from(20)));
    test('P(10,3) = 720', () => expect(Combinatorics.nPr(10, 3), BigInt.from(720)));
    test('P(n,0) = 1', () => expect(Combinatorics.nPr(7, 0), BigInt.one));
    test('r > n throws', () => expect(() => Combinatorics.nPr(3, 5), throwsA(isA<CombinatoricsException>())));
  });

  group('Combinatorics — nCr', () {
    test('C(5,2) = 10', () => expect(Combinatorics.nCr(5, 2), BigInt.from(10)));
    test('C(10,3) = 120', () => expect(Combinatorics.nCr(10, 3), BigInt.from(120)));
    test('C(n,0) = 1', () => expect(Combinatorics.nCr(7, 0), BigInt.one));
    test('C(n,n) = 1', () => expect(Combinatorics.nCr(5, 5), BigInt.one));
    test('symmetry: C(6,2) == C(6,4)', () => expect(Combinatorics.nCr(6, 2), Combinatorics.nCr(6, 4)));
  });
}
