import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parlamento_pt/features/deputies/presentation/providers/deputies_filter_provider.dart';

class DeputiesFilterBar extends ConsumerStatefulWidget {
  const DeputiesFilterBar({super.key});

  @override
  ConsumerState<DeputiesFilterBar> createState() => _DeputiesFilterBarState();
}

class _DeputiesFilterBarState extends ConsumerState<DeputiesFilterBar> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearFilters() {
    _searchController.clear();
    clearDeputiesFilters(ref);
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = ref.watch(searchQueryProvider);
    final selectedParty = ref.watch(selectedPartyProvider);
    final parties = ref.watch(availablePartiesProvider);
    final hasActiveFilters = searchQuery.isNotEmpty || selectedParty != null;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Pesquisar deputado...',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: (value) {
              ref.read(searchQueryProvider.notifier).state = value;
            },
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: InputDecorator(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String?>(
                      isExpanded: true,
                      value: selectedParty,
                      items: [
                        const DropdownMenuItem<String?>(
                          value: null,
                          child: Text('Todos os partidos'),
                        ),
                        ...parties.map(
                          (party) => DropdownMenuItem<String?>(
                            value: party,
                            child: Text(party),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        ref.read(selectedPartyProvider.notifier).state = value;
                      },
                    ),
                  ),
                ),
              ),
              if (hasActiveFilters) ...[
                const SizedBox(width: 8),
                TextButton(
                  onPressed: _clearFilters,
                  child: const Text('Limpar'),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
