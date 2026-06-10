import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parlamento_pt/features/deputies/presentation/widgets/party_badge.dart';

void main() {
  group('PartyBadge Widget Tests', () {
    testWidgets('renders party name correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: PartyBadge(partyName: 'PS')),
        ),
      );

      expect(find.text('PS'), findsOneWidget);
    });

    testWidgets(
      'uses theme primary color by default when no color is provided',
      (WidgetTester tester) async {
        final themeData = ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        );

        await tester.pumpWidget(
          MaterialApp(
            theme: themeData,
            home: const Scaffold(body: PartyBadge(partyName: 'PSD')),
          ),
        );

        final containerFinder = find.byType(Container);
        expect(containerFinder, findsOneWidget);

        final containerWidget = tester.widget<Container>(containerFinder);
        final decoration = containerWidget.decoration as BoxDecoration;

        final expectedColor = themeData.colorScheme.primary.withValues(
          alpha: 0.12,
        );
        expect(decoration.color, expectedColor);

        final textWidget = tester.widget<Text>(find.text('PSD'));
        expect(textWidget.style?.color, themeData.colorScheme.primary);
      },
    );

    testWidgets('uses custom color when provided', (WidgetTester tester) async {
      const customColor = Colors.red;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PartyBadge(partyName: 'BE', color: customColor),
          ),
        ),
      );

      final containerFinder = find.byType(Container);
      expect(containerFinder, findsOneWidget);

      final containerWidget = tester.widget<Container>(containerFinder);
      final decoration = containerWidget.decoration as BoxDecoration;

      expect(decoration.color, customColor.withValues(alpha: 0.12));

      final textWidget = tester.widget<Text>(find.text('BE'));
      expect(textWidget.style?.color, customColor);
    });
  });
}
