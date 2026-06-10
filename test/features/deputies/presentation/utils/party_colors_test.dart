import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parlamento_pt/features/deputies/presentation/utils/party_colors.dart';

void main() {
  group('PartyColors', () {
    test('returns expected colors for known parties', () {
      expect(PartyColors.forParty('PS'), const Color(0xFFE91E8C));
      expect(PartyColors.forParty('psd'), const Color(0xFFF57C00));
      expect(PartyColors.forParty(' CH '), const Color(0xFF1565C0));
      expect(PartyColors.forParty('IL'), const Color(0xFF0277BD));
      expect(PartyColors.forParty('BE'), const Color(0xFFD32F2F));
      expect(PartyColors.forParty('PCP'), const Color(0xFF8B0000));
      expect(PartyColors.forParty('L'), const Color(0xFF9ACD32));
      expect(PartyColors.forParty('LIVRE'), const Color(0xFF9ACD32));
      expect(PartyColors.forParty('PAN'), const Color(0xFF00897B));
      expect(PartyColors.forParty('JPP'), const Color(0xFF1B5E20));
    });

    test('returns null for unknown party', () {
      expect(PartyColors.forParty('UNKNOWN'), isNull);
      expect(PartyColors.forParty(''), isNull);
    });
  });
}
