import 'package:diacritic/diacritic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parlamento_pt/features/deputies/domain/deputy.dart';
import 'package:parlamento_pt/features/deputies/presentation/providers/deputies_provider.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final selectedPartyProvider = StateProvider<String?>((ref) => null);

final availablePartiesProvider = Provider<List<String>>((ref) {
  final deputiesAsync = ref.watch(deputiesProvider);

  return deputiesAsync.maybeWhen(
    data: (deputies) {
      final parties = deputies.map((deputy) => deputy.partidoAtual).toSet().toList();
      parties.sort();
      return parties;
    },
    orElse: () => const [],
  );
});

final filteredDeputiesProvider = Provider<List<Deputy>>((ref) {
  final deputiesAsync = ref.watch(deputiesProvider);
  final searchQuery = ref.watch(searchQueryProvider);
  final selectedParty = ref.watch(selectedPartyProvider);

  return deputiesAsync.maybeWhen(
    data: (deputies) => filterDeputies(
      deputies,
      searchQuery: searchQuery,
      selectedParty: selectedParty,
    ),
    orElse: () => const [],
  );
});

/// Filters [deputies] by accent-insensitive name search and optional party.
List<Deputy> filterDeputies(
  List<Deputy> deputies, {
  required String searchQuery,
  required String? selectedParty,
}) {
  return deputies.where((deputy) {
    if (selectedParty != null && deputy.partidoAtual != selectedParty) {
      return false;
    }

    if (searchQuery.isEmpty) {
      return true;
    }

    final normalizedName =
        removeDiacritics(deputy.nomeParlamentar.toLowerCase());
    final normalizedQuery = removeDiacritics(searchQuery.toLowerCase());
    return normalizedName.contains(normalizedQuery);
  }).toList();
}

void clearDeputiesFilters(WidgetRef ref) {
  ref.read(searchQueryProvider.notifier).state = '';
  ref.read(selectedPartyProvider.notifier).state = null;
}
