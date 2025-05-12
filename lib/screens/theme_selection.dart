import 'package:flutter/material.dart';
import 'package:mathscool/services/exercise_service.dart';
import 'package:mathscool/screens/exercise_screen.dart';
import 'package:provider/provider.dart';

class ThemeSelectionScreen extends StatelessWidget {
  final String level;

  const ThemeSelectionScreen({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    final exerciseService = Provider.of<ExerciseService>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Thèmes - $level')),
      body: FutureBuilder<List<String>>(
        future: exerciseService.getThemesByLevel(level),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Erreur de chargement'));
          }

          final themes = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: themes.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}