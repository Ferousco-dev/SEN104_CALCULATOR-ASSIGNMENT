abstract final class NumberFormatter {
  static const int _maxSigFigs = 10;
  static const double _expThreshold = 1e12;
  static const double _smallThreshold = 1e-6;

  static String format(double value) {
    if (value.isNaN || value.isInfinite) return 'Error';

    if (value == 0) return '0';

    final abs = value.abs();

    if (abs >= _expThreshold || (abs < _smallThreshold && abs > 0)) {
      return _exponential(value);
    }

    return _fixed(value);
  }

  static String _fixed(double value) {
    // Use toPrecision equivalent: limit to _maxSigFigs significant figures
    final formatted = value.toStringAsPrecision(_maxSigFigs);
    // Remove trailing zeros after decimal
    if (formatted.contains('.')) {
      return formatted.replaceAll(RegExp(r'\.?0+$'), '');
    }
    return formatted;
  }

  static String _exponential(double value) {
    final s = value.toStringAsExponential(6).replaceAll(RegExp(r'\.?0+(e)'), r'$1');
    // Normalise exponent sign: e+7 -> e7, e-7 -> e-7
    return s.replaceAll('e+', 'e');
  }

  static String formatBigInt(BigInt value) {
    final s = value.toString();
    // If result exceeds 20 digits, switch to exponential-style notation
    if (s.length > 20) {
      final d = double.tryParse(s);
      if (d != null) return _exponential(d);
      // Format manually: keep first 10 significant digits
      final digits = s.startsWith('-') ? s.substring(1) : s;
      final sign = s.startsWith('-') ? '-' : '';
      final exp = digits.length - 1;
      final mantissa = '${digits[0]}.${digits.substring(1, 7).replaceAll(RegExp(r'0+$'), '')}';
      return '$sign${mantissa}e$exp';
    }
    return s;
  }
}
