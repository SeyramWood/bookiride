import 'package:bookihub/src/shared/constant/colors.dart';
import 'package:flutter/material.dart';

class LightTheme {
  static themeData() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: blue),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        color: white,
      ),
      scaffoldBackgroundColor: bg,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
          backgroundColor: MaterialStateProperty.all(blue),
          foregroundColor: MaterialStateProperty.all(white),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: black,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        headlineMedium: TextStyle(
          fontSize: 16,
          color: black,
          fontWeight: FontWeight.w500,
        ),
        // headlineSmall:
        //     TextStyle(color: titleColor, fontFamily: 'Inter', fontSize: 17),
        bodyLarge: TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        bodySmall: TextStyle(
          fontFamily: 'Inter',
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
