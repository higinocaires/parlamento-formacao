import 'package:flutter/material.dart';

/// Brand-like colors for Portuguese parliamentary parties.
///
/// The votoaberto API does not provide colors — this map is app-side only.
class PartyColors {
  PartyColors._();

  static const _colors = <String, Color>{
    'PS': Color(0xFFE91E8C), // Rosa
    'PSD': Color(0xFFF57C00), // Laranja
    'CH': Color(0xFF1565C0), // Chega — azul
    'CHEGA': Color(0xFF1565C0),
    'IL': Color(0xFF0277BD), // Iniciativa Liberal — azul claro / marinho
    'BE': Color(0xFFD32F2F), // Vermelho
    'PCP': Color(0xFF8B0000), // Vermelho escuro
    'PEV': Color(0xFF2E7D32), // Verdes (often with PCP)
    'L': Color(0xFF9ACD32), // Livre — verde alface
    'LIVRE': Color(0xFF9ACD32),
    'PAN': Color(0xFF00897B), // Azul-esverdeado
    'JPP': Color(0xFF1B5E20), // Verde escuro
  };

  /// Returns a color for [partyAcronym], or null if unknown.
  static Color? forParty(String partyAcronym) {
    final key = partyAcronym.trim().toUpperCase();
    if (key.isEmpty) return null;
    return _colors[key];
  }
}
