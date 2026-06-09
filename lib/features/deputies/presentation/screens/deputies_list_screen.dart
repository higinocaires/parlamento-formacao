import 'package:flutter/material.dart';

class DeputiesListScreen extends StatelessWidget {
  const DeputiesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deputados'),
      ),
      body: const SizedBox.shrink(),
    );
  }
}
