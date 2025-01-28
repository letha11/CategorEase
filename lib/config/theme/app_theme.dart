import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryBackground = Color(0xFF0D1B2A);
  static const Color secondaryBackground = Color(0xFF1B263B);
  static const Color primaryInput = Color(0xFF415A78);
  static const Color primaryDivider = Color(0xFF415A78);
  static const Color primaryText = Color(0xFFE0E1DD);
  static const Color primaryButton = Color(0xFFE6E6E6);
  static const Color activeColor = Color(0xFF347BD5);
  static const Color errorColor = Color(0xFFD84040);

  static const colorScheme = ColorScheme.dark(
    surface: primaryBackground,
    onSurface: primaryText,
    primary: primaryBackground,
    onPrimary: primaryText,
    secondary: secondaryBackground,
    onSecondary: primaryText,
  );

  static final TextTheme textTheme = TextTheme(
    titleLarge: TextStyle(
      color: colorScheme.onSurface,
      fontSize: 36,
      fontWeight: FontWeight.bold,
      letterSpacing: calculateLetterSpacing(36, -7),
      fontFamily: 'Inter',
    ),
    titleMedium: TextStyle(
      color: colorScheme.onSurface,
      fontSize: 24,
      fontWeight: FontWeight.bold,
      letterSpacing: calculateLetterSpacing(24, -7),
      fontFamily: 'Inter',
    ),
    titleSmall: TextStyle(
      color: colorScheme.onSurface,
      fontSize: 18,
      fontWeight: FontWeight.bold,
      letterSpacing: calculateLetterSpacing(18, -7),
      fontFamily: 'Inter',
    ),
    bodyLarge: TextStyle(
      color: colorScheme.onSurface,
      fontSize: 14,
      letterSpacing: calculateLetterSpacing(14, -4),
      fontFamily: 'Inter',
    ),
    bodyMedium: TextStyle(
      color: colorScheme.onSurface,
      fontSize: 12,
      letterSpacing: calculateLetterSpacing(12, -4),
      fontFamily: 'Inter',
    ),
    bodySmall: TextStyle(
      color: colorScheme.onSurface,
      fontSize: 10,
      letterSpacing: calculateLetterSpacing(10, -4),
      fontFamily: 'Inter',
    ),
    labelMedium: TextStyle(
      color: colorScheme.surface,
      fontSize: 16,
      letterSpacing: calculateLetterSpacing(16, -2),
      fontWeight: FontWeight.bold,
      fontFamily: 'Inter',
    ),
    labelSmall: TextStyle(
      color: colorScheme.onSurface,
      fontSize: 16,
      fontFamily: 'Inter',
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: colorScheme.surface,
    canvasColor: colorScheme.surface,
    colorScheme: colorScheme,
    focusColor: primaryInput,
    textTheme: textTheme,
    fontFamily: 'Inter',
    appBarTheme: AppBarTheme(
      centerTitle: false,
      backgroundColor: colorScheme.secondary,
      titleTextStyle: textTheme.titleLarge,
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: colorScheme.onSurface,
      // selectionColor: colorScheme.onSurface,
      selectionHandleColor: colorScheme.onSurface,
    ),
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      fillColor: primaryInput,
      filled: true,
      errorStyle: textTheme.bodySmall?.copyWith(
        color: errorColor,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
      hintStyle: textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurface.withOpacity(0.5),
        fontSize: 12,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w300,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        backgroundColor: primaryButton,
        foregroundColor: colorScheme.surface,
        textStyle: textTheme.labelMedium,
        padding: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
  );

  static final ThemeData lightTheme = darkTheme;
  static double calculateLetterSpacing(
          double fontSize, double figmaPercentageLetterSpacing) =>
      fontSize * (figmaPercentageLetterSpacing / 100);
}
