import 'package:flutter/material.dart';
import 'package:parlamento_pt/features/deputies/data/mock_deputies.dart';
import 'package:parlamento_pt/features/deputies/presentation/widgets/deputy_card.dart';

class DeputiesListScreen extends StatelessWidget {
  const DeputiesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Deputados')),
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
