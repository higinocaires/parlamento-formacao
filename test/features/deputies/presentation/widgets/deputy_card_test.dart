import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parlamento_pt/features/deputies/presentation/widgets/deputy_card.dart';
import 'package:parlamento_pt/features/deputies/presentation/widgets/party_badge.dart';

void main() {
  group('DeputyCard Widget Tests', () {
    testWidgets('renders name and party badge correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DeputyCard(name: 'António Costa', party: 'PS'),
          ),
        ),
      );

      expect(find.text('António Costa'), findsOneWidget);
      expect(find.byType(PartyBadge), findsOneWidget);
      expect(find.text('PS'), findsOneWidget);
    });

    testWidgets('computes initials correctly when no image is provided', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DeputyCard(name: 'Luis Montenegro da Silva', party: 'PSD'),
          ),
        ),
      );

      // Should show 'LS' since first name is Luis and last is Silva (split by space)
      expect(find.text('LS'), findsOneWidget);
    });

    testWidgets('triggers onTap callback when tapped', (
      WidgetTester tester,
    ) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DeputyCard(
              name: 'Pedro Nuno Santos',
              party: 'PS',
              onTap: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(DeputyCard));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });
  });
}
