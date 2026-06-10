import 'package:flutter/material.dart';
import 'package:parlamento_pt/features/deputies/presentation/widgets/deputy_card.dart';

class DeputiesListScreen extends StatelessWidget {
  const DeputiesListScreen({super.key});

  // Hardcoded mock list of 5 deputies
  static const List<Map<String, dynamic>> _mockDeputies = [
    {
      'name': 'Luís Montenegro',
      'party': 'PSD',
      'partyColor': Colors.orange,
      'imageUrl': '',
    },
    {
      'name': 'Pedro Nuno Santos',
      'party': 'PS',
      'partyColor': Colors.pink,
      'imageUrl': '',
    },
    {
      'name': 'André Ventura',
      'party': 'CH',
      'partyColor': Colors.blue,
      'imageUrl': '',
    },
    {
      'name': 'Rui Rocha',
      'party': 'IL',
      'partyColor': Colors.cyan,
      'imageUrl': '',
    },
    {
      'name': 'Mariana Mortágua',
      'party': 'BE',
      'partyColor': Colors.red,
      'imageUrl': '',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Deputados')),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _mockDeputies.length,
        itemBuilder: (context, index) {
          final deputy = _mockDeputies[index];
          return DeputyCard(
            name: deputy['name'] as String,
            party: deputy['party'] as String,
            partyColor: deputy['partyColor'] as Color?,
            imageUrl: deputy['imageUrl'] as String?,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Selecionou ${deputy['name']}'),
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
