import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parlamento_pt/features/deputies/data/deputies_repository.dart';
import 'package:parlamento_pt/features/deputies/domain/deputy.dart';

final deputiesRepositoryProvider = Provider<DeputiesRepository>((ref) {
  return DeputiesRepository();
});

class DeputiesNotifier extends AsyncNotifier<List<Deputy>> {
  @override
  Future<List<Deputy>> build() async {
    return ref.read(deputiesRepositoryProvider).fetchAllDeputies();
  }

  /// Reloads deputies from the API (e.g. after an error or manual refresh).
  Future<void> refresh() async {
    state = const AsyncLoading<List<Deputy>>();
    state = await AsyncValue.guard(
      () => ref.read(deputiesRepositoryProvider).fetchAllDeputies(),
    );
  }
}

final deputiesProvider =
    AsyncNotifierProvider<DeputiesNotifier, List<Deputy>>(DeputiesNotifier.new);
