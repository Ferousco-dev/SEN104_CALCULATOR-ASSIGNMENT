import 'package:flutter_test/flutter_test.dart';
import 'package:mycalculator/core/math/statistics.dart';

void main() {
  group('Statistics — compute', () {
    final data = [2.0, 4.0, 4.0, 4.0, 5.0, 5.0, 7.0, 9.0];
    late StatResult r;

    setUpAll(() => r = Statistics.compute(data));

    test('count', () => expect(r.count, 8));
    test('sum', () => expect(r.sum, closeTo(40, 1e-10)));
    test('mean', () => expect(r.mean, closeTo(5.0, 1e-10)));
    test('median', () => expect(r.median, closeTo(4.5, 1e-10)));
    test('mode', () => expect(r.modes, [4.0]));
    test('min', () => expect(r.min, 2.0));
    test('max', () => expect(r.max, 9.0));
    test('range', () => expect(r.range, closeTo(7.0, 1e-10)));
    test('population variance', () => expect(r.variancePop, closeTo(4.0, 1e-10)));
    test('population stddev', () => expect(r.stddevPop, closeTo(2.0, 1e-10)));
    test('sample variance', () => expect(r.varianceSample, closeTo(4.571428, 1e-5)));
  });

  group('Statistics — edge cases', () {
    test('single element: no sample stddev', () {
      final r = Statistics.compute([5.0]);
      expect(r.stddevSample.isNaN, isTrue);
    });

    test('no mode when all values unique', () {
      final r = Statistics.compute([1.0, 2.0, 3.0]);
      expect(r.modes, isEmpty);
    });

    test('multiple modes', () {
      final r = Statistics.compute([1.0, 1.0, 2.0, 2.0, 3.0]);
      expect(r.modes, containsAll([1.0, 2.0]));
    });

    test('empty list throws', () {
      expect(() => Statistics.compute([]), throwsA(isA<StatisticsException>()));
    });
  });

  group('Statistics — parse', () {
    test('comma separated', () {
      expect(Statistics.parse('1,2,3'), [1.0, 2.0, 3.0]);
    });

    test('space separated', () {
      expect(Statistics.parse('1 2 3'), [1.0, 2.0, 3.0]);
    });

    test('mixed separators', () {
      expect(Statistics.parse('1, 2 3'), [1.0, 2.0, 3.0]);
    });

    test('invalid token throws', () {
      expect(() => Statistics.parse('1 abc 3'), throwsA(isA<StatisticsException>()));
    });
  });
}
