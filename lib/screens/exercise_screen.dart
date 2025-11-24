import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:mathscool/models/exercise_model.dart';
import 'package:mathscool/data/static_exercises.dart';
import 'package:mathscool/utils/colors.dart';
import 'package:mathscool/screens/help_screen.dart';
import 'package:mathscool/screens/progress_screen.dart';
import 'package:mathscool/services/progress_service.dart';
import 'package:mathscool/models/user_model.dart';

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

class _ExerciseScreenState extends State<ExerciseScreen>
    with SingleTickerProviderStateMixin {
  late final List<Exercise> _exercises;
  int _currentIndex = 0;
  int _score = 0;
  String _feedbackMessage = '';
  bool _showFeedback = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late final ProgressService _progressService;
  bool _isSaving = false;

  // Helper pour savoir si on est au collège
  bool get isCollege => ['6ème', '5ème', '4ème', '3ème'].contains(widget.level);

  @override
  void initState() {
    super.initState();
    _progressService = ProgressService();
    // Sécurité : Si la liste est null, on met une liste vide pour éviter le crash
    _exercises = staticExercises[widget.level]?[widget.theme] ?? [];

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    // Ne lancer l'animation que s'il y a des exercices
    if (_exercises.isNotEmpty) {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _answerQuestion(int selectedIndex) async {
    if (_isSaving) return;

    final user = Provider.of<AppUser?>(context, listen: false);
    if (user == null) return;

    final exercise = _exercises[_currentIndex];
    final isCorrect = selectedIndex == exercise.correctAnswer;

    setState(() {
      _isSaving = true;
      if (isCorrect) {
        _score++;
        // Message adapté selon l'âge
        _feedbackMessage = isCollege
            ? "Excellent ! Réponse correcte ✅"
            : "Bravo ! 🥳 C'est correct 🎉";
      } else {
        _feedbackMessage = isCollege
            ? "Incorrect. Retente ta chance ! 💪"
            : "Essaie encore ! 😊 Tu peux le faire 💪";
      }
      _showFeedback = true;
    });

    try {
      await _progressService.updateResult(
        user.uid,
        exercise.question,
        selectedIndex,
        exercise.correctAnswer,
      );
    } catch (e) {
      print('Erreur lors de la sauvegarde: $e');
    }

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _showFeedback = false;
        _isSaving = false;
        if (_currentIndex < _exercises.length - 1) {
          _currentIndex++;
          _animationController.reset();
          _animationController.forward();
        } else {
          _currentIndex++;
        }
      });
    }
  }

  void _goToManual() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HelpScreen(),
      ),
    );
  }

  void _goToProgress() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProgressScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1. GESTION DU CAS "PAS D'EXERCICES"
    if (_exercises.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.christ,
          title: Text(widget.theme),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.construction, size: 60, color: Colors.grey[400]),
              const SizedBox(height: 16),
              const Text(
                "Exercices bientôt disponibles !",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                "Le professeur prépare les sujets de ${widget.theme}",
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xDBD12C2C),
              Color(0xDBA30E0E),
            ],
          ),
        ),
        child: Stack(
          children: [
            CustomPaint(
              painter: _MathBackgroundPainter(),
              size: MediaQuery.of(context).size,
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
            if (_isSaving)
              Container(
                color: Colors.black26,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.christ.withOpacity(0.85),
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 28),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.theme,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  '${widget.level} • Score: $_score/${_exercises.length}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildExerciseScreen() {
    final exercise = _exercises[_currentIndex];

    // 2. DÉTECTION DE LA LONGUEUR DES RÉPONSES
    // Si une réponse fait plus de 15 caractères, on passe en mode liste verticale
    bool useListView = exercise.options.any((option) => option.length > 15);

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Barre de progression (étoiles)
            Container(
              height: 18,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Row(
                      children: List.generate(
                        _exercises.length,
                            (index) => Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: index <= _currentIndex
                                  ? AppColors.accent
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: index < _currentIndex
                                ? const Icon(Icons.star, color: Colors.yellow, size: 12)
                                : null,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Numéro de question
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.emoji_events,
                    size: 24,
                    color: AppColors.secondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Question ${_currentIndex + 1}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20), // Réduit un peu l'espace

            // Carte de la question
            Hero(
              tag: 'question_card',
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 15,
                      spreadRadius: 1,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  border: Border.all(
                    color: AppColors.christ.withOpacity(0.5),
                    width: 3,
                  ),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.lightbulb_outline,
                      size: 40,
                      color: Color(0xFFFFC107),
                    ),
                    const SizedBox(height: 16),
                    RichText(
                      textAlign: TextAlign.center,
                      text: buildMathText(
                        exercise.question,
                        fontSize: isCollege && exercise.question.length > 50 ? 20 : 26,
                        color: AppColors.christ,   // 🎯 couleur des questions
                      ),
                    )


                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Grille ou Liste des réponses
            Expanded(
              child: useListView
                  ? ListView.builder( // Mode liste pour les longues réponses (Algèbre/Collège)
                itemCount: exercise.options.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: _buildOptionButton(index, exercise, isList: true),
                  );
                },
              )
                  : GridView.builder( // Mode grille pour les réponses courtes (Primaire)
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.3,
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 18,
                ),
                itemCount: exercise.options.length,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  return _buildOptionButton(index, exercise);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(int index, Exercise exercise, {bool isList = false}) {
    final colors = [
      const Color(0xFFFF7043),
      const Color(0xDBA30E0E),
      const Color(0xFF66BB6A),
      const Color(0xDBD12C2C),
    ];

    final color = colors[index % colors.length];

    return GestureDetector(
      onTap: _isSaving ? null : () => _answerQuestion(index),
      child: Container(
        height: isList ? 70 : null, // Hauteur fixe en mode liste
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color,
              color.withOpacity(0.7),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: Colors.white.withOpacity(0.6),
            width: 3,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: RichText(
              textAlign: TextAlign.center,
              text: buildMathText(
                exercise.options[index],
                color: Colors.white,   // 🎯 réponses en blanc
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeedbackOverlay() {
    final isCorrect = _feedbackMessage.contains("Bravo") || _feedbackMessage.contains("correcte");

    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 400),
          curve: Curves.elasticOut,
          builder: (context, double value, child) {
            return Transform.scale(
              scale: value,
              child: child,
            );
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
              border: Border.all(
                color: isCorrect ? Colors.green : Colors.orange,
                width: 4,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isCorrect
                        ? Colors.green.withOpacity(0.2)
                        : Colors.orange.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isCorrect ? Icons.celebration : Icons.emoji_objects,
                    size: 60,
                    color: isCorrect ? Colors.green : Colors.orange,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _feedbackMessage,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isCorrect ? Colors.green : Colors.orange,
                    height: 1.3,
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
    final double percentage = (_score / _exercises.length) * 100.0;
    final bool isMathKid = percentage >= 100.0;
    final bool isOnRightTrack = percentage >= 50.0 && percentage < 100.0;

    // 3. VOCABULAIRE ADAPTÉ (MathKid vs Expert)
    String titleText;
    if (isCollege) {
      titleText = isMathKid ? '🎉 Tu es un Expert ! 🎉' : (isOnRightTrack ? '🌟 Bien joué ! 🌟' : '🙂 Courage !');
    } else {
      titleText = isMathKid ? '🎉 Tu es un Mathkid! 🎉' : (isOnRightTrack ? '🌟 Tu es sur la bonne voie! 🌟' : '🙂 Presque un Mathkid!');
    }

    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 15,
                    spreadRadius: 5,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Lottie.asset(
                isMathKid || isOnRightTrack
                    ? 'assets/animations/success.json'
                    : 'assets/animations/encouragement.json',
                width: 160,
                height: 160,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
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
                    titleText,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isMathKid
                          ? AppColors.christ
                          : isOnRightTrack
                          ? Colors.green
                          : Colors.orange,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isMathKid
                        ? 'Parfait! Tu maîtrises parfaitement!'
                        : isOnRightTrack
                        ? 'Excellent travail! Continue comme ça!'
                        : 'N\'hésite pas à consulter notre manuel pour t\'améliorer!',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 18,
                    width: 180,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Stack(
                      children: [
                        Container(
                          height: 18,
                          width: 180 * (_score / _exercises.length.toDouble()),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isMathKid
                                  ? [AppColors.christ, AppColors.secondary]
                                  : isOnRightTrack
                                  ? [Colors.green, Colors.lightGreen]
                                  : [Colors.orange, Colors.deepOrange],
                            ),
                            borderRadius: BorderRadius.circular(9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${percentage.toInt()}% correct',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (percentage >= 50.0) ...[
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ElevatedButton.icon(
                        onPressed: _goToProgress,
                        icon: const Icon(Icons.trending_up, color: Colors.white, size: 18),
                        label: const Text(
                          'Voir ma progression',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF9C27B0),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 5,
                        ),
                      ),
                    ),
                  ],
                  // Le reste reste identique
                  if (percentage < 50.0) ...[
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ElevatedButton.icon(
                        onPressed: _goToManual,
                        icon: const Icon(Icons.menu_book_rounded, color: Colors.white, size: 18),
                        label: const Text(
                          'Consulter le Manuel',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 5,
                        ),
                      ),
                    ),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.home_rounded, color: Colors.white, size: 18),
                          label: const Text(
                            'Retour',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.christ,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _currentIndex = 0;
                              _score = 0;
                              _animationController.reset();
                              _animationController.forward();
                            });
                          },
                          icon: const Icon(Icons.replay_rounded, color: Colors.white, size: 18),
                          label: const Text(
                            'Rejouer',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondary,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _MathBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    // Ajout de symboles du collège
    final mathSymbols = ['+', '-', '×', '÷', '=', '%', '√', 'x', 'y', 'π'];
    final random = Random();

    for (int i = 0; i < 30; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final symbolSize = random.nextDouble() * 30 + 10;

      if (i % 3 == 0) {
        canvas.drawCircle(Offset(x, y), symbolSize / 2, paint);
      } else if (i % 3 == 1) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: '${random.nextInt(10)}',
            style: TextStyle(
              color: Colors.white.withOpacity(0.15),
              fontSize: symbolSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(x, y));
      } else {
        final textPainter = TextPainter(
          text: TextSpan(
            text: mathSymbols[random.nextInt(mathSymbols.length)],
            style: TextStyle(
              color: Colors.white.withOpacity(0.15),
              fontSize: symbolSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(x, y));
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
/// Convertit un texte contenant ^ en exposants
InlineSpan buildMathText(
    String input, {
      double fontSize = 22,
      Color color = Colors.black,
    }) {
  final Map<String, String> expo = {
    "0": "⁰",
    "1": "¹",
    "2": "²",
    "3": "³",
    "4": "⁴",
    "5": "⁵",
    "6": "⁶",
    "7": "⁷",
    "8": "⁸",
    "9": "⁹",
    "-": "⁻",
  };

  List<InlineSpan> spans = [];

  for (int i = 0; i < input.length; i++) {
    if (input[i] == '^' && i + 1 < input.length) {
      String exp = "";
      int j = i + 1;

      while (j < input.length && expo.containsKey(input[j])) {
        exp += expo[input[j]]!;
        j++;
      }

      spans.add(
        WidgetSpan(
          child: Transform.translate(
            offset: const Offset(0, -8),
            child: Text(
              exp,
              style: TextStyle(
                fontSize: fontSize * 0.65,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
      );

      i = j - 1;
    } else {
      spans.add(
        TextSpan(
          text: input[i],
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      );
    }
  }

  return TextSpan(children: spans);
}

