import 'package:flutter/material.dart';

abstract final class AppTypography {
  static const String _family = 'Inter';

  static const TextStyle displayValue = TextStyle(
    fontFamily: _family,
    fontSize: 72,
    fontWeight: FontWeight.w300,
    height: 1.0,
    fontFeatures: [FontFeature.tabularFigures()],
    letterSpacing: -1.5,
  );

  static const TextStyle displayValueSmall = TextStyle(
    fontFamily: _family,
    fontSize: 48,
    fontWeight: FontWeight.w300,
    height: 1.0,
    fontFeatures: [FontFeature.tabularFigures()],
    letterSpacing: -1.0,
  );

  static const TextStyle expressionLine = TextStyle(
    fontFamily: _family,
    fontSize: 20,
    fontWeight: FontWeight.w400,
    height: 1.4,
    fontFeatures: [FontFeature.tabularFigures()],
    letterSpacing: 0,
  );

  static const TextStyle keyLabel = TextStyle(
    fontFamily: _family,
    fontSize: 22,
    fontWeight: FontWeight.w400,
    height: 1.0,
    letterSpacing: 0,
  );

  static const TextStyle keyLabelSmall = TextStyle(
    fontFamily: _family,
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 1.0,
    letterSpacing: 0,
  );

  static const TextStyle modeLabel = TextStyle(
    fontFamily: _family,
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 1.0,
    letterSpacing: 0,
  );

  static const TextStyle hint = TextStyle(
    fontFamily: _family,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: 0,
  );
}
