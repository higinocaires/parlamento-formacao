import 'package:flutter/material.dart';
import 'package:parlamento_pt/features/deputies/presentation/widgets/party_badge.dart';

class DeputiesListScreen extends StatelessWidget {
  const DeputiesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Deputados')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Exemplos de PartyBadge:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: const [
                  PartyBadge(partyName: 'PS', color: Colors.pink),
                  PartyBadge(partyName: 'PSD', color: Colors.orange),
                  PartyBadge(partyName: 'CH', color: Colors.blue),
                  PartyBadge(partyName: 'BE', color: Colors.red),
                  PartyBadge(partyName: 'Sem Partido'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
