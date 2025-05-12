import 'package:flutter/material.dart';
import 'package:mathscool/models/exercise_model.dart';
import 'package:mathscool/services/exercise_service.dart';
import 'package:mathscool/services/user_service.dart';
import 'package:provider/provider.dart';

class ExerciseScreen extends StatefulWidget {
  final String level;
  final String theme;

  const ExerciseScreen({
    super.key,
    required this.level,
    required this.theme,
  });

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  late final Stream<List<Exercise>> _exercisesStream;
  int _currentIndex = 0;
  int _score = 0;

  @override
  void initState() {
    super.initState();
    final exerciseService = Provider.of<ExerciseService>(context, listen: false);
    _exercisesStream = exerciseService.getExercisesByLevel(widget.level);
  }

  void _answerQuestion(int selectedIndex, Exercise currentExercise) async {
    final userService = Provider.of<UserService>(context, listen: false);
    final isCorrect = selectedIndex == currentExercise.correctAnswer;

    // Mettre à jour la progression
    await userService.recordExerciseAttempt(
      level: widget.level,
      theme: widget.theme,
      isCorrect: isCorrect,
    );

    if (mounted) {
      setState(() {
        if (isCorrect) _score++;
      });
    }

    // Passer à la question suivante
    if (mounted) {
      setState(() => _currentIndex++);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.level} - ${widget.theme}')),
      body: StreamBuilder<List<Exercise>>(
        stream: _exercisesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Erreur de chargement'));
          }

          final exercises = snapshot.data!
              .where((ex) => ex.theme == widget.theme)
              .toList();

          if (_currentIndex >= exercises.length) {
            return _buildResultsScreen(exercises.length);
          }

          return _buildExerciseScreen(exercises[_currentIndex], exercises.length);
        },
      ),
    );
  }

  Widget _buildExerciseScreen(Exercise exercise, int totalExercises) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          LinearProgressIndicator(
            value: (_currentIndex + 1) / totalExercises,
          ),
          const SizedBox(height: 20),
          Text(
            'Question ${_currentIndex + 1}/$totalExercises',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 30),
          Text(
            exercise.question,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          if (exercise.imageUrl != null)
            Image.network(exercise.imageUrl!),
          const SizedBox(height: 40),
          Expanded(
            child: ListView.builder(
              itemCount: exercise.options.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(exercise.options[index]),
                    onTap: () => _answerQuestion(index, exercise),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsScreen(int totalExercises) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.celebration, size: 80, color: Colors.amber),
          const SizedBox(height: 20),
          Text(
            'Bravo !',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 20),
          Text(
            'Score: $_score / $totalExercises',
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Retour aux thèmes'),
          ),
        ],
      ),
    );
  }
}