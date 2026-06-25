import 'package:flutter/material.dart';

abstract final class AppPalette {
  // Dark theme
  static const Color bg = Color(0xFF0F0F13);
  static const Color surfaceTile = Color(0xFF15151B);
  static const Color surfaceRaised = Color(0xFF1F1F26);
  static const Color keyNumber = Color(0xFF24242C);
  static const Color keyPressed = Color(0xFF2E2E37);
  static const Color accent = Color(0xFFE7A33C);
  static const Color accentPressed = Color(0xFFF2B257);
  static const Color textPrimary = Color(0xFFF4F4F6);
  static const Color textSecondary = Color(0xFF8A8A93);
  static const Color hairline = Color(0xFF2A2A31);

  // Light theme mirrors — same accent, inverted neutrals
  static const Color bgLight = Color(0xFFF5F5F7);
  static const Color surfaceTileLight = Color(0xFFEBEBEE);
  static const Color surfaceRaisedLight = Color(0xFFFFFFFF);
  static const Color keyNumberLight = Color(0xFFDFDFE5);
  static const Color keyPressedLight = Color(0xFFD0D0D8);
  static const Color textPrimaryLight = Color(0xFF0F0F13);
  static const Color textSecondaryLight = Color(0xFF5A5A63);
  static const Color hairlineLight = Color(0xFFCDCDD4);
}
