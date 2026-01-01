import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      // Color scheme based on Design Language System
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF4ECDC4), // Surface Teal
        brightness: Brightness.light,
      ),
      // Typography using custom fonts
      fontFamily: 'Comfortaa',
      textTheme: const TextTheme(
        // Headlines use Sniglet
        displayLarge: TextStyle(
          fontFamily: 'Sniglet',
          fontWeight: FontWeight.w800,
          color: Color(0xFF2D3436),
        ),
        displayMedium: TextStyle(
          fontFamily: 'Sniglet',
          fontWeight: FontWeight.w800,
          color: Color(0xFF2D3436),
        ),
        displaySmall: TextStyle(
          fontFamily: 'Sniglet',
          fontWeight: FontWeight.w400,
          color: Color(0xFF2D3436),
        ),
        // Body text uses Comfortaa
        bodyLarge: TextStyle(
          fontFamily: 'Comfortaa',
          fontWeight: FontWeight.w600,
          color: Color(0xFF2D3436),
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Comfortaa',
          fontWeight: FontWeight.w500,
          color: Color(0xFF2D3436),
        ),
        // Button labels
        labelLarge: TextStyle(
          fontFamily: 'Comfortaa',
          fontWeight: FontWeight.w700,
          color: Color(0xFFF7F9F9),
        ),
      ),
    );
  }
}
