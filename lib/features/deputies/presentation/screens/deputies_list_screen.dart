import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:parlamento_pt/core/theme/theme_mode_provider.dart';
import 'package:parlamento_pt/features/deputies/data/deputies_repository.dart';
import 'package:parlamento_pt/features/deputies/presentation/providers/deputies_provider.dart';
import 'package:parlamento_pt/features/deputies/presentation/utils/party_colors.dart';
import 'package:parlamento_pt/features/deputies/presentation/widgets/deputy_card.dart';

class DeputiesListScreen extends ConsumerWidget {
  const DeputiesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(themeModeProvider);
    final deputiesAsync = ref.watch(deputiesProvider);
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
      body: deputiesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) {
          final message = error is DeputiesRepositoryException
              ? error.message
              : 'Ocorreu um erro ao carregar os deputados.';

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(message, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () =>
                        ref.read(deputiesProvider.notifier).refresh(),
                    child: const Text('Tentar novamente'),
                  ),
                ],
              ),
            ),
          );
        },
        data: (deputies) {
          if (deputies.isEmpty) {
            return const Center(child: Text('Nenhum deputado encontrado'));
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: deputies.length,
            itemBuilder: (context, index) {
              final deputy = deputies[index];
              return DeputyCard(
                name: deputy.nomeParlamentar,
                party: deputy.partidoAtual,
                partyColor: PartyColors.forParty(deputy.partidoAtual),
                imageUrl: deputy.photoUrl,
                onTap: () => context.push('/deputado/${deputy.depCadId}'),
              );
            },
          );
        },
      ),
    );
  }
}
