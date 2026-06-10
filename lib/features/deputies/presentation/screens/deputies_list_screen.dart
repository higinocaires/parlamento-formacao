import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parlamento_pt/core/theme/theme_mode_provider.dart';
import 'package:parlamento_pt/features/deputies/data/deputies_repository.dart';
import 'package:parlamento_pt/features/deputies/domain/deputy.dart';
import 'package:parlamento_pt/features/deputies/presentation/utils/party_colors.dart';
import 'package:parlamento_pt/features/deputies/presentation/widgets/deputy_card.dart';

class DeputiesListScreen extends ConsumerStatefulWidget {
  const DeputiesListScreen({super.key, this.repository});

  /// Optional override for tests. Defaults to [DeputiesRepository].
  final DeputiesRepository? repository;

  @override
  ConsumerState<DeputiesListScreen> createState() => _DeputiesListScreenState();
}

class _DeputiesListScreenState extends ConsumerState<DeputiesListScreen> {
  late Future<List<Deputy>> _deputiesFuture;

  @override
  void initState() {
    super.initState();
    _loadDeputies();
  }

  void _loadDeputies() {
    final repository = widget.repository ?? DeputiesRepository();
    setState(() {
      _deputiesFuture = repository.fetchAllDeputies();
    });
  }

  @override
  Widget build(BuildContext context) {
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
      body: FutureBuilder<List<Deputy>>(
        future: _deputiesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            final message = snapshot.error is DeputiesRepositoryException
                ? (snapshot.error! as DeputiesRepositoryException).message
                : 'Ocorreu um erro ao carregar os deputados.';

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      message,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: _loadDeputies,
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              ),
            );
          }

          final deputies = snapshot.data ?? [];
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
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Selecionou ${deputy.nomeParlamentar}'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
