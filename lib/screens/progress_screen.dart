import 'package:flutter/material.dart';
import 'package:mathscool/utils/colors.dart';
import 'package:mathscool/widgets/progress_chart.dart';
import 'package:mathscool/data/static_exercises.dart';
import 'package:mathscool/data/user_results.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final UserResults _userResults = UserResults();
  Map<String, double> userProgressByCategory = {};
  Map<String, double> userProgressByGrade = {};
  bool showGradeProgress = false; // Pour basculer entre les vues

  @override
  void initState() {
    super.initState();
    _initializeProgressData();
  }

  Future<void> _initializeProgressData() async {
    await _userResults.loadResults(); // Charger les résultats de l'utilisateur
    setState(() {
      userProgressByCategory = _calculateProgressByCategory();
      userProgressByGrade = _calculateProgressByGrade();
    });
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
                        const Text(
                          'Mes Badges',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: userProgressByCategory.entries.map((entry) {
                            final earned = entry.value >= 0.7; // Badge obtenu si progression >= 70%
                            return _buildBadge(entry.key, _getBadgeIcon(entry.key), earned);
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                backgroundColor: !showGradeProgress ? AppColors.primary : Colors.grey[300],
                foregroundColor: !showGradeProgress ? Colors.white : Colors.black,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                ),
              ),
              child: const Text('Par catégorie'),
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
                backgroundColor: showGradeProgress ? AppColors.primary : Colors.grey[300],
                foregroundColor: showGradeProgress ? Colors.white : Colors.black,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
              ),
              child: const Text('Par niveau'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
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
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 48), // Placeholder for alignment
        ],
      ),
    );
  }

  Widget _buildBadge(String title, IconData icon, bool earned) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: earned ? AppColors.primary : Colors.grey[300],
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 30, color: earned ? Colors.white : Colors.grey),
        ),
        const SizedBox(height: 5),
        Text(
          title,
          style: TextStyle(
            color: earned ? Colors.black : Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  IconData _getBadgeIcon(String theme) {
    switch (theme.toLowerCase()) {
      case 'addition':
        return Icons.add;
      case 'soustraction':
        return Icons.remove;
      case 'multiplication':
        return Icons.close;
      case 'division':
        return Icons.percent;
      case 'géométrie':
        return Icons.square_foot;
      default:
        return Icons.star;
    }
  }
}