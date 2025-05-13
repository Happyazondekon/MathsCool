import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mathscool/models/exercise_model.dart';
import 'package:mathscool/data/static_exercises.dart';
import 'package:mathscool/utils/colors.dart';

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
  String _feedbackMessage = '';
  bool _showFeedback = false;

  @override
  void initState() {
    super.initState();
    _exercises = staticExercises[widget.level]?[widget.theme] ?? [];
  }

  void _answerQuestion(int selectedIndex) {
    final isCorrect = selectedIndex == _exercises[_currentIndex].correctAnswer;

    setState(() {
      if (isCorrect) {
        _score++;
        _feedbackMessage = "Bravo ! C'est correct 🎉";
      } else {
        _feedbackMessage = "Essaie encore ! Tu peux le faire 💪";
      }
      _showFeedback = true;

      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _showFeedback = false;
          _currentIndex++;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fond animé avec des motifs mathématiques
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primary.withOpacity(0.9),
                  Colors.white,
                ],
              ),
            ),
            child: CustomPaint(
              painter: _MathBackgroundPainter(),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: _currentIndex < _exercises.length
                      ? _buildExerciseScreen()
                      : _buildResultsScreen(),
                ),
              ],
            ),
          ),

          if (_showFeedback) _buildFeedbackOverlay(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
          boxShadow: [
      BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 8,
      offset: const Offset(0, 4),
      )],
    ),
    child: Row(
    children: [
    IconButton(
    icon: const Icon(Icons.arrow_back, color: Colors.white),
    onPressed: () => Navigator.pop(context),
    ),
    Expanded(
    child: Center(
    child: Text(
    '${widget.level} - ${widget.theme}',
    style: const TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    ),
    ),
    ),
    ),
    ],
    ),
    );
  }

  Widget _buildExerciseScreen() {
    final exercise = _exercises[_currentIndex];
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
      // Barre de progression avec indicateur visuel
      Stack(
      children: [
      Container(
      height: 12,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      Container(
        height: 12,
        width: MediaQuery.of(context).size.width * (_currentIndex + 1) / _exercises.length,
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            colors: [AppColors.secondary, AppColors.primary],
          ),
        ),
      ),
      ],
    ),

    const SizedBox(height: 20),

    // Compteur de questions avec icône
    Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Icon(Icons.help_outline, color: AppColors.primary, size: 24),
    const SizedBox(width: 8),
    Text(
    'Question ${_currentIndex + 1}/${_exercises.length}',
    style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
    ),
    ),
    ],
    ),

    const SizedBox(height: 30),

    // Carte de question avec effet 3D
    Transform(
    transform: Matrix4.identity()..rotateZ(0.02),
    child: Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
    BoxShadow(
    color: Colors.black.withOpacity(0.15),
    blurRadius: 15,
    offset: const Offset(5, 5),
    )],
    border: Border.all(
    color: AppColors.primary.withOpacity(0.3),
    width: 2,
    ),
    ),
    child: Text(
    exercise.question,
    style: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
    ),
    textAlign: TextAlign.center,
    ),
    ),
    ),

    const SizedBox(height: 40),

    // Options de réponse sous forme de boutons colorés
    Expanded(
    child: GridView.builder(
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    childAspectRatio: 1.5,
    crossAxisSpacing: 15,
    mainAxisSpacing: 15,
    ),
    itemCount: exercise.options.length,
    itemBuilder: (context, index) {
    return ElevatedButton(
    onPressed: () => _answerQuestion(index),
    style: ElevatedButton.styleFrom(
    backgroundColor: _getOptionColor(index),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15),
    ),
    elevation: 5,
    padding: const EdgeInsets.all(12),
    ),
    child: Text(
    exercise.options[index],
    style: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    ),
    textAlign: TextAlign.center,
    ),
    );
    },
    ),
    ),
    ],
    ),
    );
  }

  Widget _buildFeedbackOverlay() {
    return Center(
      child: AnimatedScale(
        scale: _showFeedback ? 1.0 : 0.8,
        duration: const Duration(milliseconds: 300),
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
              border: Border.all(
                color: _feedbackMessage.contains("Bravo")
                    ? Colors.green
                    : Colors.orange,
                width: 3,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _feedbackMessage.contains("Bravo")
                      ? Icons.celebration
                      : Icons.auto_awesome,
                  size: 60,
                  color: _feedbackMessage.contains("Bravo")
                      ? Colors.amber
                      : AppColors.primary,
                ),
                const SizedBox(height: 15),
                Text(
                  _feedbackMessage,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultsScreen() {
    final bool isMathKid = _score >= _exercises.length / 2;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animation de résultat
            Lottie.asset(
              isMathKid
                  ? 'assets/animations/success.json'
                  : 'assets/animations/encouragement.json',
              width: 200,
              height: 200,
            ),

            const SizedBox(height: 30),

            // Titre avec emoji
            Text(
              isMathKid ? 'Tu es un Mathkid! 🎉' : 'Pas encore un Mathkid',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),

            if (!isMathKid) Text(
              'Révise encore!',
              style: TextStyle(
                fontSize: 22,
                color: AppColors.primary.withOpacity(0.8),
              ),
            ),

            const SizedBox(height: 20),

            // Score avec indicateur visuel
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Ton score',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '$_score / ${_exercises.length}',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: _score / _exercises.length,
                    backgroundColor: Colors.grey[200],
                    color: isMathKid ? Colors.green : Colors.orange,
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Bouton de retour avec icône
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.home, color: Colors.white),
              label: const Text(
                'Retour aux thèmes',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 30,
                ),
                elevation: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getOptionColor(int index) {
    final colors = [
      AppColors.primary,
      AppColors.secondary,
      Color(0xFF4CAF50), // Vert
      Color(0xFF9C27B0), // Violet
    ];
    return colors[index % colors.length];
  }
}

class _MathBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    // Dessiner des motifs mathématiques en arrière-plan
    for (int i = 0; i < 20; i++) {
      final x = Random().nextDouble() * size.width;
      final y = Random().nextDouble() * size.height;
      final radius = Random().nextDouble() * 15 + 5;

      // Alterner entre cercles et symboles mathématiques
      if (i % 2 == 0) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      } else {
        final textPainter = TextPainter(
          text: TextSpan(
            text: ['+', '-', '×', '÷', '='][Random().nextInt(5)],
            style: TextStyle(
              color: Colors.white.withOpacity(0.05),
              fontSize: radius * 2,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(x - radius, y - radius));
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}