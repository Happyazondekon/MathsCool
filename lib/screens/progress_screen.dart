import 'package:flutter/material.dart';
import 'package:mathscool/utils/colors.dart';
import 'package:mathscool/widgets/progress_chart.dart';
import 'package:mathscool/data/static_exercises.dart';
import 'package:mathscool/data/user_results.dart';
import 'package:confetti/confetti.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> with SingleTickerProviderStateMixin {
  final UserResults _userResults = UserResults();
  Map<String, double> userProgressByCategory = {};
  Map<String, double> userProgressByGrade = {};
  bool showGradeProgress = false; // Pour basculer entre les vues
  late AnimationController _badgeAnimationController;
  late ConfettiController _confettiController;
  double overallProgress = 0.0;
  bool hasMathKidBadge = false;

  @override
  void initState() {
    super.initState();
    _badgeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _initializeProgressData();
  }

  @override
  void dispose() {
    _badgeAnimationController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _initializeProgressData() async {
    await _userResults.loadResults(); // Charger les résultats de l'utilisateur
    setState(() {
      userProgressByCategory = _calculateProgressByCategory();
      userProgressByGrade = _calculateProgressByGrade();
      overallProgress = _calculateOverallProgress();
      hasMathKidBadge = overallProgress >= 0.8;

      if (hasMathKidBadge) {
        _badgeAnimationController.forward();
        _confettiController.play();
      }
    });
  }

  double _calculateOverallProgress() {
    if (userProgressByCategory.isEmpty) return 0.0;

    double totalProgress = userProgressByCategory.values.fold(0.0, (sum, value) => sum + value);
    return totalProgress / userProgressByCategory.length;
  }

  Map<String, double> _calculateProgressByCategory() {
    Map<String, double> progress = {};
    Map<String, int> totalExercisesByCategory = {};
    Map<String, int> correctExercisesByCategory = {};

    // Initialiser les compteurs
    staticExercises.forEach((grade, categories) {
      categories.forEach((category, exercises) {
        if (!totalExercisesByCategory.containsKey(category)) {
          totalExercisesByCategory[category] = 0;
          correctExercisesByCategory[category] = 0;
        }
        totalExercisesByCategory[category] = totalExercisesByCategory[category]! + exercises.length;
      });
    });

    // Calculer les réponses correctes
    staticExercises.forEach((grade, categories) {
      categories.forEach((category, exercises) {
        exercises.forEach((exercise) {
          int? userAnswerIndex = _userResults.getAnswer(exercise.question);
          if (userAnswerIndex != null && userAnswerIndex == exercise.correctAnswer) {
            correctExercisesByCategory[category] = correctExercisesByCategory[category]! + 1;
          }
        });
      });
    });

    // Calculer le pourcentage de progression
    totalExercisesByCategory.forEach((category, total) {
      progress[category] = total > 0 ? correctExercisesByCategory[category]! / total : 0.0;
    });

    return progress;
  }

  Map<String, double> _calculateProgressByGrade() {
    Map<String, double> progress = {};
    Map<String, int> totalExercisesByGrade = {};
    Map<String, int> correctExercisesByGrade = {};

    // Initialiser les compteurs
    staticExercises.forEach((grade, categories) {
      totalExercisesByGrade[grade] = 0;
      correctExercisesByGrade[grade] = 0;

      categories.forEach((category, exercises) {
        totalExercisesByGrade[grade] = totalExercisesByGrade[grade]! + exercises.length;
      });
    });

    // Calculer les réponses correctes
    staticExercises.forEach((grade, categories) {
      categories.forEach((category, exercises) {
        exercises.forEach((exercise) {
          int? userAnswerIndex = _userResults.getAnswer(exercise.question);
          if (userAnswerIndex != null && userAnswerIndex == exercise.correctAnswer) {
            correctExercisesByGrade[grade] = correctExercisesByGrade[grade]! + 1;
          }
        });
      });
    });

    // Calculer le pourcentage de progression
    totalExercisesByGrade.forEach((grade, total) {
      progress[grade] = total > 0 ? correctExercisesByGrade[grade]! / total : 0.0;
    });

    return progress;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fond dégradé
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.primary, Colors.white],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                _buildToggleButtons(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        ProgressChart(
                          progressData: showGradeProgress
                              ? userProgressByGrade
                              : userProgressByCategory,
                          title: showGradeProgress
                              ? 'Progression par niveau'
                              : 'Progression par catégorie',
                        ),
                        const SizedBox(height: 30),

                        // Badge MathKid spécial
                        if (hasMathKidBadge)
                          _buildMathKidBadge(),

                        const SizedBox(height: 30),
                        const Text(
                          'Mes Badges',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Comic Sans MS',
                          ),
                        ),
                        const SizedBox(height: 20),
                        Wrap(
                          spacing: 15,
                          runSpacing: 15,
                          children: userProgressByCategory.entries.map((entry) {
                            final earned = entry.value >= 0.7; // Badge obtenu si progression >= 70%
                            return _buildFancyBadge(entry.key, earned, entry.value);
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              particleDrag: 0.05,
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              gravity: 0.1,
              shouldLoop: false,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
                Colors.yellow,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMathKidBadge() {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.5, end: 1.0).animate(
        CurvedAnimation(
          parent: _badgeAnimationController,
          curve: Curves.elasticOut,
        ),
      ),
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.purple.shade100,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withOpacity(0.3),
              blurRadius: 15,
              spreadRadius: 5,
            )
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Colors.purple.shade300, Colors.purple.shade700],
                  center: Alignment.topLeft,
                  radius: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.5),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.school,
                      size: 70,
                      color: Colors.yellow[400],
                    ),
                    const Text(
                      "80%",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'MATHKID',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
                fontFamily: 'Comic Sans MS',
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Super Champion!',
              style: TextStyle(
                fontSize: 14,
                color: Colors.purple,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    showGradeProgress = false;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: !showGradeProgress ? AppColors.primary : Colors.white,
                  foregroundColor: !showGradeProgress ? Colors.white : Colors.grey[700],
                  elevation: !showGradeProgress ? 2 : 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      bottomLeft: Radius.circular(25),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.category,
                      size: 18,
                      color: !showGradeProgress ? Colors.white : Colors.grey[700],
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'Par catégorie',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    showGradeProgress = true;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: showGradeProgress ? AppColors.primary : Colors.white,
                  foregroundColor: showGradeProgress ? Colors.white : Colors.grey[700],
                  elevation: showGradeProgress ? 2 : 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.school,
                      size: 18,
                      color: showGradeProgress ? Colors.white : Colors.grey[700],
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'Par niveau',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Text(
              'Ma Progression',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Comic Sans MS',
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 48), // Placeholder for alignment
        ],
      ),
    );
  }

  Widget _buildFancyBadge(String title, bool earned, double progress) {
    final themeColors = _getBadgeThemeColors(title);

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Badge extérieur
            Container(
              width: 85,
              height: 85,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: earned
                    ? RadialGradient(
                  colors: [themeColors['light']!, themeColors['dark']!],
                  center: Alignment.topLeft,
                  radius: 1.5,
                )
                    : null,
                color: earned ? null : Colors.grey[300],
                boxShadow: earned ? [
                  BoxShadow(
                    color: themeColors['dark']!.withOpacity(0.4),
                    blurRadius: 6,
                    spreadRadius: 2,
                  ),
                ] : null,
              ),
            ),

            // Icône du badge
            Positioned(
              child: Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: earned ? Colors.white.withOpacity(0.85) : Colors.grey[200],
                ),
                child: Center(
                  child: Icon(
                    _getBadgeIcon(title),
                    size: 35,
                    color: earned ? themeColors['dark'] : Colors.grey,
                  ),
                ),
              ),
            ),

            // Indicateur de progrès
            if (progress > 0 && !earned)
              Positioned(
                bottom: 5,
                child: Container(
                  width: 50,
                  height: 12,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.white,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getProgressColor(progress),
                      ),
                    ),
                  ),
                ),
              ),

            // Animation d'étoiles pour badges gagnés
            if (earned)
              ...List.generate(3, (index) {
                return Positioned(
                  top: index * 25.0,
                  right: index * 10.0 - 15.0,
                  child: Icon(
                    Icons.star,
                    size: 15,
                    color: Colors.yellow[700],
                  ),
                );
              }),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: earned ? themeColors['light'] : Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: earned ? themeColors['dark'] : Colors.grey[700],
              fontSize: 12,
              fontWeight: FontWeight.bold,
              fontFamily: 'Comic Sans MS',
            ),
          ),
        ),
        if (earned)
          Text(
            '${(progress * 100).toInt()}%',
            style: TextStyle(
              color: themeColors['dark'],
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
      ],
    );
  }

  Map<String, Color> _getBadgeThemeColors(String theme) {
    switch (theme.toLowerCase()) {
      case 'addition':
        return {'light': Colors.green[300]!, 'dark': Colors.green[700]!};
      case 'soustraction':
        return {'light': Colors.red[300]!, 'dark': Colors.red[700]!};
      case 'multiplication':
        return {'light': Colors.blue[300]!, 'dark': Colors.blue[700]!};
      case 'division':
        return {'light': Colors.orange[300]!, 'dark': Colors.orange[700]!};
      case 'géométrie':
        return {'light': Colors.purple[300]!, 'dark': Colors.purple[700]!};
      default:
        return {'light': Colors.teal[300]!, 'dark': Colors.teal[700]!};
    }
  }

  IconData _getBadgeIcon(String theme) {
    switch (theme.toLowerCase()) {
      case 'addition':
        return Icons.exposure_plus_1;
      case 'soustraction':
        return Icons.exposure_minus_1;
      case 'multiplication':
        return Icons.close;
      case 'division':
        return Icons.functions;
      case 'géométrie':
        return Icons.category;
      default:
        return Icons.star;
    }
  }

  Color _getProgressColor(double value) {
    if (value < 0.4) return Colors.red[400]!;
    if (value < 0.7) return Colors.orange[400]!;
    return Colors.green[400]!;
  }
}