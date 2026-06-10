import 'package:flutter/material.dart';

/// A class representing mock deputy data for UI design and validation.
class MockDeputy {
  final String name;
  final String party;
  final Color partyColor;
  final String imageUrl;

  const MockDeputy({
    required this.name,
    required this.party,
    required this.partyColor,
    this.imageUrl = '',
  });
}

/// A comprehensive list of mock deputies representing various political parties.
const List<MockDeputy> mockDeputies = [
  MockDeputy(name: 'Luís Montenegro', party: 'PSD', partyColor: Colors.orange),
  MockDeputy(name: 'Pedro Nuno Santos', party: 'PS', partyColor: Colors.pink),
  MockDeputy(name: 'André Ventura', party: 'CH', partyColor: Colors.blue),
  MockDeputy(name: 'Rui Rocha', party: 'IL', partyColor: Colors.cyan),
  MockDeputy(name: 'Mariana Mortágua', party: 'BE', partyColor: Colors.red),
  MockDeputy(
    name: 'Paulo Raimundo',
    party: 'PCP',
    partyColor: Colors.redAccent,
  ),
  MockDeputy(
    name: 'Rui Tavares',
    party: 'LIVRE',
    partyColor: Colors.lightGreen,
  ),
  MockDeputy(name: 'Nuno Melo', party: 'CDS-PP', partyColor: Colors.blueAccent),
  MockDeputy(name: 'Inês Sousa Real', party: 'PAN', partyColor: Colors.teal),
  MockDeputy(
    name: 'Augusto Santos Silva',
    party: 'PS',
    partyColor: Colors.pink,
  ),
  MockDeputy(name: 'Hugo Soares', party: 'PSD', partyColor: Colors.orange),
  MockDeputy(name: 'Rita Matias', party: 'CH', partyColor: Colors.blue),
];
