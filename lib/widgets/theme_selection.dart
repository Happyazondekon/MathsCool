import 'package:flutter/material.dart';
import 'package:mathscool/screens/exercise_screen.dart';

class ThemeSelectionScreen extends StatelessWidget {
  final String level;
  final List<String> themes = const [
    'Addition', 'Soustraction', 'Multiplication', 'Division', 'Géométrie'
  ];

  const ThemeSelectionScreen({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Thèmes - $level')),
      body: ListView.builder(
        itemCount: themes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(themes[index]),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExerciseScreen(
                    level: level,
                    theme: themes[index],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}