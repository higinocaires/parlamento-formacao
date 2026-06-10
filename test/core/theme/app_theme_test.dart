import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parlamento_pt/core/theme/app_theme.dart';

void main() {
  group('AppTheme Tests', () {
    test('light theme has correct configuration', () {
      final theme = AppTheme.light;

      expect(theme.useMaterial3, isTrue);
      expect(theme.brightness, Brightness.light);
      expect(theme.colorScheme.primary, const Color(0xFF8A1C2A));
      expect(theme.colorScheme.secondary, const Color(0xFF1E4C33));
    });

    test('dark theme has correct configuration', () {
      final theme = AppTheme.dark;

      expect(theme.useMaterial3, isTrue);
      expect(theme.brightness, Brightness.dark);
      expect(theme.colorScheme.primary, const Color(0xFFE26D7B));
      expect(theme.colorScheme.secondary, const Color(0xFF6F9C7D));
    });
  });
}
