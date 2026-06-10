import 'package:flutter/material.dart';

/// AppTheme defines the custom Light and Dark theme configurations.
///
/// Designed with a Parliament-inspired palette:
/// - Light Theme: Off-white neutral backgrounds, deep burgundy primary, and green secondary accents.
/// - Dark Theme: Deep charcoal backgrounds, soft rose-red primary, and soft green secondary accents.
class AppTheme {
  AppTheme._();

  // Parliament-inspired color palette constants
  static const Color _lightPrimary = Color(0xFF8A1C2A); // Deep Burgundy Red
  static const Color _lightSecondary = Color(0xFF1E4C33); // Deep Green Accent
  static const Color _lightBackground = Color(0xFFF9F9F6); // Soft Warm Off-White
  static const Color _lightSurface = Color(0xFFFFFFFF);

  static const Color _darkPrimary = Color(0xFFE26D7B); // Soft Burgundy Rose
  static const Color _darkSecondary = Color(0xFF6F9C7D); // Soft Green Accent
  static const Color _darkBackground = Color(0xFF121212); // Near Black
  static const Color _darkSurface = Color(0xFF1E1E1C); // Very Dark Slate

  /// The ThemeData configuration for the Light Theme.
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _lightPrimary,
        brightness: Brightness.light,
        primary: _lightPrimary,
        secondary: _lightSecondary,
        surface: _lightSurface,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
      ),
      scaffoldBackgroundColor: _lightBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: _lightBackground,
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      cardTheme: CardThemeData(
        color: _lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  /// The ThemeData configuration for the Dark Theme.
  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _darkPrimary,
        brightness: Brightness.dark,
        primary: _darkPrimary,
        secondary: _darkSecondary,
        surface: _darkSurface,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
      ),
      scaffoldBackgroundColor: _darkBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: _darkBackground,
        foregroundColor: Colors.white70,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      cardTheme: CardThemeData(
        color: _darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
