class CombinatoricsException implements Exception {
  const CombinatoricsException(this.message);
  final String message;
  @override
  String toString() => 'CombinatoricsException: $message';
}

abstract final class Combinatorics {
  static BigInt factorial(int n) {
    if (n < 0) throw CombinatoricsException('factorial domain error: $n');
    var result = BigInt.one;
    for (var i = 2; i <= n; i++) {
      result *= BigInt.from(i);
    }
    return result;
  }

  static BigInt nPr(int n, int r) {
    _guard(n, r);
    // n! / (n-r)!  — computed iteratively to avoid two full factorials
    var result = BigInt.one;
    for (var i = n - r + 1; i <= n; i++) {
      result *= BigInt.from(i);
    }
    return result;
  }

  static BigInt nCr(int n, int r) {
    _guard(n, r);
    if (r > n - r) {
      // Use symmetry: C(n,r) == C(n, n-r)
      return nCr(n, n - r);
    }
    var result = BigInt.one;
    for (var i = 0; i < r; i++) {
      result = result * BigInt.from(n - i) ~/ BigInt.from(i + 1);
    }
    return result;
  }

  static void _guard(int n, int r) {
    if (n < 0 || r < 0) throw CombinatoricsException('n and r must be non-negative');
    if (r > n) throw CombinatoricsException('r must be <= n');
  }
}
