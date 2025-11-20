import 'package:flutter/material.dart';
import 'package:mathscool/utils/colors.dart';
import 'package:mathscool/widgets/progress_chart.dart';
import 'package:mathscool/data/static_exercises.dart';
import 'package:mathscool/data/user_results.dart';
import 'package:confetti/confetti.dart';
// Importer notre nouveau widget
import '../widgets/theme_badge.dart';

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
                colors: [AppColors.christ, Colors.white],
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

                        // Section des badges avec un cadre attrayant
                        _buildBadgesSection(),
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

  Widget _buildBadgesSection() {
    int earnedBadges = userProgressByCategory.values.where((progress) => progress >= 0.7).length;
    int totalBadges = userProgressByCategory.length;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.indigo.shade50,
            Colors.purple.shade50,
            Colors.pink.shade50,
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: AppColors.christ.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.christ.withOpacity(0.15),
            blurRadius: 15,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.8),
            blurRadius: 10,
            spreadRadius: -5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Motifs décoratifs en arrière-plan
          Positioned(
            top: -10,
            right: -10,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.yellow.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -5,
            left: -5,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Étoiles décoratives
          Positioned(
            top: 20,
            left: 30,
            child: Icon(
              Icons.star,
              color: Colors.yellow.withOpacity(0.3),
              size: 16,
            ),
          ),
          Positioned(
            top: 40,
            right: 40,
            child: Icon(
              Icons.star,
              color: Colors.orange.withOpacity(0.3),
              size: 12,
            ),
          ),
          Positioned(
            bottom: 30,
            right: 60,
            child: Icon(
              Icons.star,
              color: Colors.pink.withOpacity(0.3),
              size: 14,
            ),
          ),

          // Contenu principal
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // En-tête de la section avec icône et titre
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.secondary,
                            AppColors.secondary.withOpacity(0.7),
                          ],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.secondary.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.emoji_events,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Mes Badges',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'ComicNeue',
                            color: AppColors.christ,
                          ),
                        ),
                        Text(
                          '$earnedBadges/$totalBadges badges obtenus',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.christ,
                            fontFamily: 'ComicNeue',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Barre de progression des badges
                Container(
                  height: 12,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final progressWidth = totalBadges > 0
                          ? constraints.maxWidth * (earnedBadges / totalBadges)
                          : 0.0;

                      return Stack(
                        children: [
                          Container(
                            height: 12,
                            width: progressWidth,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.secondary,
                                  AppColors.accent,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  earnedBadges == totalBadges
                      ? '🎉 Tous les badges débloqués ! Champion !'
                      : 'Continue pour débloquer ${totalBadges - earnedBadges} badge${totalBadges - earnedBadges > 1 ? 's' : ''} !',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: earnedBadges == totalBadges ? Colors.green.shade700 : Colors.grey.shade600,
                    fontFamily: 'ComicNeue',
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 24),

                // Grille des badges
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.8),
                      width: 1,
                    ),
                  ),
                  child: Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    alignment: WrapAlignment.center,
                    children: userProgressByCategory.entries.map((entry) {
                      final earned = entry.value >= 0.7;
                      return TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0.0, end: 1.0),
                        duration: Duration(milliseconds: 500 + (userProgressByCategory.keys.toList().indexOf(entry.key) * 200)),
                        curve: Curves.elasticOut,
                        builder: (context, animationValue, child) {
                          return Transform.scale(
                            scale: animationValue,
                            child: ThemeBadge(
                              theme: entry.key,
                              level: entry.key == 'Addition' ? '1' :
                              entry.key == 'Soustraction' ? '2' :
                              entry.key == 'Multiplication' ? '3' :
                              entry.key == 'Division' ? '4' : '5',
                              obtained: earned,
                              progress: entry.value,
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 16),

                // Message d'encouragement
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue.shade100,
                        Colors.indigo.shade100,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.blue.shade200,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: Colors.blue.shade600,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          earnedBadges == 0
                              ? 'Commence à résoudre des exercices pour gagner tes premiers badges !'
                              : earnedBadges == totalBadges
                              ? 'Bravo ! Tu es un véritable MathKid ! 🌟'
                              : 'Super ! Continue comme ça pour débloquer tous les badges !',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue.shade700,
                            fontFamily: 'ComicNeue',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
                fontFamily: 'ComicNeue',
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
                  backgroundColor: !showGradeProgress ? AppColors.christ : Colors.white,
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
                  backgroundColor: showGradeProgress ? AppColors.christ : Colors.white,
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
        color: AppColors.christ,
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
                fontFamily: 'ComicNeue',
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 48), // Placeholder for alignment
        ],
      ),
    );
  }
}