import 'dart:math' as math;

class StatisticsException implements Exception {
  const StatisticsException(this.message);
  final String message;
  @override
  String toString() => 'StatisticsException: $message';
}

class StatResult {
  const StatResult({
    required this.count,
    required this.sum,
    required this.mean,
    required this.median,
    required this.modes,
    required this.min,
    required this.max,
    required this.range,
    required this.variancePop,
    required this.varianceSample,
    required this.stddevPop,
    required this.stddevSample,
  });

  final int count;
  final double sum;
  final double mean;
  final double median;
  final List<double> modes;
  final double min;
  final double max;
  final double range;
  final double variancePop;
  final double varianceSample;
  final double stddevPop;
  final double stddevSample;
}

abstract final class Statistics {
  static StatResult compute(List<double> data) {
    if (data.isEmpty) throw const StatisticsException('Dataset is empty');

    final sorted = List.of(data)..sort();
    final n = data.length;
    final sum = data.fold(0.0, (a, b) => a + b);
    final mean = sum / n;
    final min = sorted.first;
    final max = sorted.last;
    final range = max - min;

    final median = _median(sorted);
    final modes = _modes(sorted);

    double varPop = 0;
    for (final v in data) {
      final d = v - mean;
      varPop += d * d;
    }
    varPop /= n;
    final stddevPop = math.sqrt(varPop);

    final varSample = n > 1 ? varPop * n / (n - 1) : double.nan;
    final stddevSample = n > 1 ? math.sqrt(varSample) : double.nan;

    return StatResult(
      count: n,
      sum: sum,
      mean: mean,
      median: median,
      modes: modes,
      min: min,
      max: max,
      range: range,
      variancePop: varPop,
      varianceSample: varSample,
      stddevPop: stddevPop,
      stddevSample: stddevSample,
    );
  }

  static double _median(List<double> sorted) {
    final n = sorted.length;
    if (n.isOdd) return sorted[n ~/ 2];
    return (sorted[n ~/ 2 - 1] + sorted[n ~/ 2]) / 2.0;
  }

  static List<double> _modes(List<double> sorted) {
    final freq = <double, int>{};
    for (final v in sorted) {
      freq[v] = (freq[v] ?? 0) + 1;
    }
    final maxFreq = freq.values.reduce(math.max);
    if (maxFreq == 1) return []; // no repeated value — no mode
    return freq.entries.where((e) => e.value == maxFreq).map((e) => e.key).toList()..sort();
  }

  static List<double> parse(String input) {
    final parts = input.trim().split(RegExp(r'[\s,]+'));
    final result = <double>[];
    for (final part in parts) {
      if (part.isEmpty) continue;
      final v = double.tryParse(part);
      if (v == null) throw StatisticsException('Cannot parse "$part" as a number');
      result.add(v);
    }
    return result;
  }
}
