import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parlamento_pt/features/deputies/data/deputies_repository.dart';
import 'package:parlamento_pt/features/deputies/domain/deputy.dart';
import 'package:parlamento_pt/features/deputies/presentation/providers/deputies_filter_provider.dart';
import 'package:parlamento_pt/features/deputies/presentation/providers/deputies_provider.dart';

void main() {
  const deputies = [
    Deputy(
      depCadId: 1,
      nomeParlamentar: 'José Manuel',
      partidoAtual: 'PS',
    ),
    Deputy(
      depCadId: 2,
      nomeParlamentar: 'Luís Montenegro',
      partidoAtual: 'PSD',
    ),
    Deputy(
      depCadId: 3,
      nomeParlamentar: 'André Ventura',
      partidoAtual: 'CH',
    ),
  ];

  group('filterDeputies', () {
    test('filters by accent-insensitive search query', () {
      final result = filterDeputies(
        deputies,
        searchQuery: 'jose',
        selectedParty: null,
      );

      expect(result, hasLength(1));
      expect(result.first.nomeParlamentar, 'José Manuel');
    });

    test('filters by selected party', () {
      final result = filterDeputies(
        deputies,
        searchQuery: '',
        selectedParty: 'PSD',
      );

      expect(result, hasLength(1));
      expect(result.first.nomeParlamentar, 'Luís Montenegro');
    });

    test('combines search and party filters', () {
      final result = filterDeputies(
        deputies,
        searchQuery: 'luis',
        selectedParty: 'PSD',
      );

      expect(result, hasLength(1));
      expect(result.first.nomeParlamentar, 'Luís Montenegro');
    });
  });

  group('filteredDeputiesProvider', () {
    test('derives sorted unique parties from cached deputies', () async {
      final repository = _FakeDeputiesRepository(deputies: deputies);
      final container = ProviderContainer(
        overrides: [
          deputiesRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await container.read(deputiesProvider.future);

      expect(
        container.read(availablePartiesProvider),
        ['CH', 'PS', 'PSD'],
      );
    });
  });
}

class _FakeDeputiesRepository extends DeputiesRepository {
  _FakeDeputiesRepository({required this.deputies});

  final List<Deputy> deputies;

  @override
  Future<List<Deputy>> fetchAllDeputies() async => deputies;
}
