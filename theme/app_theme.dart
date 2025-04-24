import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF3D5AFE);
  static const Color accentColor = Color(0xFF4FC3F7);
  static const Color backgroundColor = Color(0xFF121212);
  static const Color cardColor = Color(0xFF1E1E1E);
  static const Color secondaryCardColor = Color(0xFF2A2A2A);
  
  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: backgroundColor,
      primaryColor: primaryColor,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: accentColor,
        background: backgroundColor,
        surface: cardColor,
      ),
      fontFamily: 'Poppins',
      cardTheme: CardTheme(
        color: cardColor,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: cardColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 8,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 28,
        ),
        headlineMedium: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        titleLarge: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
        titleMedium: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        bodyLarge: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: Colors.white70,
          fontSize: 14,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 16,
          ),
        ),
      ),
    );
  }
  
  static ThemeData get lightTheme {
    return ThemeData.light().copyWith(
      scaffoldBackgroundColor: Colors.white,
      primaryColor: primaryColor,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: accentColor,
        background: Colors.white,
        surface: Colors.white,
      ),
      fontFamily: 'Poppins',
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 8,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 28,
        ),
        headlineMedium: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        titleLarge: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
        titleMedium: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        bodyLarge: TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: Colors.black87,
          fontSize: 14,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}
