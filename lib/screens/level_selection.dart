import 'package:flutter/material.dart';
import 'package:mathscool/screens/theme_selection.dart';

import '../widgets/level_card.dart';
import '../widgets/theme_selection.dart';

class LevelSelectionScreen extends StatelessWidget {
  const LevelSelectionScreen({super.key});

  final List<String> levels = const ['CI', 'CP', 'CE1', 'CE2', 'CM1', 'CM2'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choisis ton niveau')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.9,
        ),
        itemCount: levels.length,
        itemBuilder: (context, index) {
          return LevelCard(
            level: levels[index],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ThemeSelectionScreen(level: levels[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}