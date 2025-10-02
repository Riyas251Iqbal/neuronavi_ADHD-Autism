import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF4A90E2);
  static const Color secondaryColor = Color(0xFF50E3C2);
  static const Color backgroundColor = Color(0xFFF4F6F8);
  static const Color textColor = Color(0xFF333333);
  static const Color cardColor = Colors.white;

  static final ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    fontFamily: 'Poppins',
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: primaryColor,
      secondary: secondaryColor,
      background: backgroundColor,
    ),
    // FIX: Changed CardTheme to CardThemeData
    cardTheme: CardThemeData(
      color: cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 32),
      headlineMedium: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 24),
      bodyLarge: TextStyle(color: textColor, fontSize: 16),
      bodyMedium: TextStyle(color: Colors.black54, fontSize: 14),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: primaryColor, width: 2.0),
      ),
    ),
  );
}