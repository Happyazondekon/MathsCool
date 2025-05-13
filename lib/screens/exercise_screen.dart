import 'package:flutter/material.dart';
import 'package:mathscool/models/exercise_model.dart';
import 'package:mathscool/data/static_exercises.dart';

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
  late final List<Exercise> _exercises;
  int _currentIndex = 0;
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _exercises = staticExercises[widget.level]?[widget.theme] ?? [];
  }

  void _answerQuestion(int selectedIndex) {
    final isCorrect = selectedIndex == _exercises[_currentIndex].correctAnswer;

    setState(() {
      if (isCorrect) _score++;
      _currentIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.level} - ${widget.theme}')),
      body: _currentIndex < _exercises.length
          ? _buildExerciseScreen()
          : _buildResultsScreen(),
    );
  }

  Widget _buildExerciseScreen() {
    final exercise = _exercises[_currentIndex];
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          LinearProgressIndicator(
            value: (_currentIndex + 1) / _exercises.length,
          ),
          const SizedBox(height: 20),
          Text(
            'Question ${_currentIndex + 1}/${_exercises.length}',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 30),
          Text(
            exercise.question,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),
          Expanded(
            child: ListView.builder(
              itemCount: exercise.options.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(exercise.options[index]),
                    onTap: () => _answerQuestion(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsScreen() {
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
            'Score: $_score / ${_exercises.length}',
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