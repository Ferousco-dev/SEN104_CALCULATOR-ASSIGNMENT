import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'metrics.dart';
import 'palette.dart';
import 'typography.dart';

abstract final class AppTheme {
  static ThemeData get dark => _build(brightness: Brightness.dark);
  static ThemeData get light => _build(brightness: Brightness.light);

  static ThemeData _build({required Brightness brightness}) {
    final dark = brightness == Brightness.dark;

    final bg = dark ? AppPalette.bg : AppPalette.bgLight;
    final surface = dark ? AppPalette.surfaceRaised : AppPalette.surfaceRaisedLight;
    final textPrimary = dark ? AppPalette.textPrimary : AppPalette.textPrimaryLight;
    final textSecondary = dark ? AppPalette.textSecondary : AppPalette.textSecondaryLight;

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: AppPalette.accent,
      onPrimary: dark ? AppPalette.bg : AppPalette.bgLight,
      secondary: AppPalette.accent,
      onSecondary: dark ? AppPalette.bg : AppPalette.bgLight,
      surface: surface,
      onSurface: textPrimary,
      error: const Color(0xFFCF6679),
      onError: AppPalette.textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: bg,
      fontFamily: 'Inter',
      textTheme: TextTheme(
        displayLarge: AppTypography.displayValue.copyWith(color: textPrimary),
        displayMedium: AppTypography.displayValueSmall.copyWith(color: textPrimary),
        bodyLarge: AppTypography.expressionLine.copyWith(color: textSecondary),
        bodyMedium: AppTypography.keyLabel.copyWith(color: textPrimary),
        labelLarge: AppTypography.modeLabel.copyWith(color: textPrimary),
        labelSmall: AppTypography.hint.copyWith(color: textSecondary),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        foregroundColor: textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.modeLabel.copyWith(
          color: textPrimary,
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
        systemOverlayStyle: dark
            ? SystemUiOverlayStyle.light.copyWith(
                statusBarColor: Colors.transparent,
                systemNavigationBarColor: bg,
              )
            : SystemUiOverlayStyle.dark.copyWith(
                statusBarColor: Colors.transparent,
                systemNavigationBarColor: bg,
              ),
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: dark ? AppPalette.surfaceRaised : AppPalette.surfaceRaisedLight,
        elevation: 0,
        shape: const RoundedRectangleBorder(),
      ),
      dividerTheme: const DividerThemeData(
        thickness: AppMetrics.hairline,
        space: 0,
        color: AppPalette.hairline,
      ),
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
    );
  }
}
