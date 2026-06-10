import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parlamento_pt/features/deputies/data/deputies_repository.dart';
import 'package:parlamento_pt/features/deputies/domain/deputy.dart';
import 'package:parlamento_pt/features/deputies/presentation/providers/deputies_provider.dart';

void main() {
  group('deputiesProvider', () {
    test('fetches deputies once and caches result', () async {
      var fetchCount = 0;
      final repository = _CountingDeputiesRepository(
        deputies: const [
          Deputy(
            depCadId: 1,
            nomeParlamentar: 'Test Deputy',
            partidoAtual: 'PS',
          ),
        ],
        onFetch: () => fetchCount++,
      );

      final container = ProviderContainer(
        overrides: [
          deputiesRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      final first = await container.read(deputiesProvider.future);
      final second = await container.read(deputiesProvider.future);

      expect(first, hasLength(1));
      expect(second, first);
      expect(fetchCount, 1);
    });

    test('refresh refetches deputies', () async {
      var fetchCount = 0;
      final repository = _CountingDeputiesRepository(
        deputies: const [
          Deputy(
            depCadId: 1,
            nomeParlamentar: 'Test Deputy',
            partidoAtual: 'PS',
          ),
        ],
        onFetch: () => fetchCount++,
      );

      final container = ProviderContainer(
        overrides: [
          deputiesRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await container.read(deputiesProvider.future);
      await container.read(deputiesProvider.notifier).refresh();
      await container.read(deputiesProvider.future);

      expect(fetchCount, 2);
    });
  });
}

class _CountingDeputiesRepository extends DeputiesRepository {
  _CountingDeputiesRepository({
    required this.deputies,
    required this.onFetch,
  });

  final List<Deputy> deputies;
  final void Function() onFetch;

  @override
  Future<List<Deputy>> fetchAllDeputies() async {
    onFetch();
    return deputies;
  }
}
