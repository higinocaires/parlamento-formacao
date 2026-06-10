import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parlamento_pt/core/theme/theme_mode_provider.dart';
import 'package:parlamento_pt/features/deputies/data/mock_deputies.dart';
import 'package:parlamento_pt/features/deputies/presentation/widgets/deputy_card.dart';

class DeputiesListScreen extends ConsumerWidget {
  const DeputiesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(themeModeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Deputados'),
        actions: [
          Switch(
            value: isDark,
            onChanged: (value) {
              ref.read(themeModeProvider.notifier).state =
                  value ? ThemeMode.dark : ThemeMode.light;
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: mockDeputies.length,
        itemBuilder: (context, index) {
          final deputy = mockDeputies[index];
          return DeputyCard(
            name: deputy.name,
            party: deputy.party,
            partyColor: deputy.partyColor,
            imageUrl: deputy.imageUrl,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Selecionou ${deputy.name}'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
