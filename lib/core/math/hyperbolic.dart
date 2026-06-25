import 'dart:math' as math;

class HyperbolicException implements Exception {
  const HyperbolicException(this.message);
  final String message;
  @override
  String toString() => 'HyperbolicException: $message';
}

abstract final class Hyperbolic {
  static double sinh(double x) => (math.exp(x) - math.exp(-x)) / 2.0;
  static double cosh(double x) => (math.exp(x) + math.exp(-x)) / 2.0;
  static double tanh(double x) {
    final e2x = math.exp(2 * x);
    return (e2x - 1) / (e2x + 1);
  }

  static double asinh(double x) => math.log(x + math.sqrt(x * x + 1));

  static double acosh(double x) {
    if (x < 1) throw HyperbolicException('acosh domain error: $x');
    return math.log(x + math.sqrt(x * x - 1));
  }

  static double atanh(double x) {
    if (x <= -1 || x >= 1) throw HyperbolicException('atanh domain error: $x');
    return 0.5 * math.log((1 + x) / (1 - x));
  }
}
