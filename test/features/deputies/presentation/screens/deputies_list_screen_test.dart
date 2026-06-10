import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parlamento_pt/core/app.dart';
import 'package:parlamento_pt/features/deputies/data/mock_deputies.dart';
import 'package:parlamento_pt/features/deputies/presentation/screens/deputies_list_screen.dart';
import 'package:parlamento_pt/features/deputies/presentation/widgets/deputy_card.dart';

void main() {
  group('DeputiesListScreen Widget Tests', () {
    testWidgets('renders list of deputies from mock data', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: DeputiesListScreen()),
        ),
      );

      // Verify page title
      expect(find.text('Deputados'), findsOneWidget);

      // Verify that DeputyCards are rendered.
      expect(find.byType(DeputyCard), findsAtLeastNWidgets(1));

      // Verify that some of the mock names are visible
      expect(find.text(mockDeputies[0].name), findsOneWidget);
      expect(find.text(mockDeputies[1].name), findsOneWidget);
      expect(find.text(mockDeputies[2].name), findsOneWidget);
    });

    testWidgets('toggles theme mode with switch', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: App(),
        ),
      );

      final switchFinder = find.byType(Switch);
      expect(switchFinder, findsOneWidget);
      expect(tester.widget<Switch>(switchFinder).value, isFalse);

      await tester.tap(switchFinder);
      await tester.pumpAndSettle();

      expect(tester.widget<Switch>(switchFinder).value, isTrue);

      await tester.tap(switchFinder);
      await tester.pumpAndSettle();

      expect(tester.widget<Switch>(switchFinder).value, isFalse);
    });

    testWidgets('shows SnackBar when deputy card is tapped', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: DeputiesListScreen()),
        ),
      );

      // Tap on the first deputy
      final firstDeputyName = mockDeputies[0].name;
      await tester.tap(find.text(firstDeputyName));
      await tester.pump(); // Start SnackBar animation

      // Verify that SnackBar is shown with the expected text
      expect(find.text('Selecionou $firstDeputyName'), findsOneWidget);
    });
  });
}
