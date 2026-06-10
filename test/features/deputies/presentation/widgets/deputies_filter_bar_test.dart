import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parlamento_pt/features/deputies/data/deputies_repository.dart';
import 'package:parlamento_pt/features/deputies/domain/deputy.dart';
import 'package:parlamento_pt/features/deputies/presentation/providers/deputies_filter_provider.dart';
import 'package:parlamento_pt/features/deputies/presentation/providers/deputies_provider.dart';
import 'package:parlamento_pt/features/deputies/presentation/widgets/deputies_filter_bar.dart';

void main() {
  group('DeputiesFilterBar', () {
    testWidgets('shows Limpar when search is active and clears filters', (
      WidgetTester tester,
    ) async {
      final repository = _FakeDeputiesRepository(
        deputies: const [
          Deputy(
            depCadId: 1,
            nomeParlamentar: 'Luís Montenegro',
            partidoAtual: 'PSD',
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            deputiesRepositoryProvider.overrideWithValue(repository),
          ],
          child: const MaterialApp(
            home: Scaffold(body: DeputiesFilterBar()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Limpar'), findsNothing);

      await tester.enterText(
        find.byType(TextField),
        'Luís',
      );
      await tester.pump();

      expect(find.text('Limpar'), findsOneWidget);

      await tester.tap(find.text('Limpar'));
      await tester.pump();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(DeputiesFilterBar)),
      );
      expect(container.read(searchQueryProvider), '');
      expect(container.read(selectedPartyProvider), isNull);
    });
  });
}

class _FakeDeputiesRepository extends DeputiesRepository {
  _FakeDeputiesRepository({required this.deputies});

  final List<Deputy> deputies;

  @override
  Future<List<Deputy>> fetchAllDeputies() async => deputies;
}
