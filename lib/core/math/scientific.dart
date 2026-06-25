import 'dart:math' as math;

class ScientificException implements Exception {
  const ScientificException(this.message);
  final String message;
  @override
  String toString() => 'ScientificException: $message';
}

abstract final class Scientific {
  static double sin(double radians) => math.sin(radians);
  static double cos(double radians) => math.cos(radians);

  static double tan(double radians) {
    // Guard for exact 90/270 degree equivalents where cos == 0
    final c = math.cos(radians);
    if (c.abs() < 1e-15) throw const ScientificException('tan is undefined at this angle');
    return math.sin(radians) / c;
  }

  static double asin(double x) {
    if (x < -1 || x > 1) throw ScientificException('asin domain error: $x');
    return math.asin(x);
  }

  static double acos(double x) {
    if (x < -1 || x > 1) throw ScientificException('acos domain error: $x');
    return math.acos(x);
  }

  static double atan(double x) => math.atan(x);

  static double ln(double x) {
    if (x <= 0) throw ScientificException('ln domain error: $x');
    return math.log(x);
  }

  static double log10(double x) {
    if (x <= 0) throw ScientificException('log10 domain error: $x');
    return math.log(x) / math.ln10;
  }

  static double logBase(double base, double x) {
    if (base <= 0 || base == 1) throw ScientificException('logBase: invalid base $base');
    if (x <= 0) throw ScientificException('logBase domain error: $x');
    return math.log(x) / math.log(base);
  }

  static double exp(double x) => math.exp(x);

  static double sqrt(double x) {
    if (x < 0) throw ScientificException('sqrt domain error: $x');
    return math.sqrt(x);
  }

  static double cbrt(double x) => x < 0 ? -math.pow(-x, 1.0 / 3.0).toDouble() : math.pow(x, 1.0 / 3.0).toDouble();

  static double pow(double base, double exp) => math.pow(base, exp).toDouble();

  static double factorial(int n) {
    if (n < 0) throw ScientificException('factorial domain error: $n');
    if (n > 170) throw ScientificException('factorial overflow: $n');
    double result = 1;
    for (var i = 2; i <= n; i++) {
      result *= i;
    }
    return result;
  }
}
