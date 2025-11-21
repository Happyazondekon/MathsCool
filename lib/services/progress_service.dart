import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mathscool/models/user_progress_model.dart';
import 'package:mathscool/data/static_exercises.dart';
import 'package:mathscool/models/exercise_model.dart';

class ProgressService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Récupérer les données de progression de l'utilisateur
  Future<UserProgress?> getUserProgress(String userId) async {
    try {
      final doc = await _firestore.collection('userProgress').doc(userId).get();

      if (doc.exists && doc.data() != null) {
        return UserProgress.fromFirestore(doc.data()!, userId);
      }

      // Si l'utilisateur n'a pas encore de données, créer une instance vide
      return UserProgress.empty(userId);
    } catch (e) {
      print('Erreur lors de la récupération de la progression: $e');
      return null;
    }
  }

  // Sauvegarder la progression de l'utilisateur
  Future<void> saveUserProgress(UserProgress progress) async {
    try {
      await _firestore
          .collection('userProgress')
          .doc(progress.userId)
          .set(progress.toFirestore(), SetOptions(merge: true));
    } catch (e) {
      print('Erreur lors de la sauvegarde de la progression: $e');
      rethrow;
    }
  }

  // Mettre à jour une réponse utilisateur
  Future<void> updateResult(String userId, String question, int answerIndex, int correctAnswer) async {
    try {
      final progress = await getUserProgress(userId);
      if (progress == null) return;

      // Mettre à jour les résultats
      final updatedResults = Map<String, int>.from(progress.results);
      updatedResults[question] = answerIndex;

      // Recalculer les progressions
      final updatedProgressByCategory = _calculateProgressByCategory(updatedResults);
      final updatedProgressByGrade = _calculateProgressByGrade(updatedResults);
      final overallProgress = _calculateOverallProgress(updatedProgressByCategory);

      // Mettre à jour les badges
      final earnedBadges = _calculateEarnedBadges(updatedProgressByCategory);
      final hasMathKidBadge = overallProgress >= 0.8;

      // Créer la nouvelle instance avec les données mises à jour
      final updatedProgress = progress.copyWith(
        results: updatedResults,
        progressByCategory: updatedProgressByCategory,
        progressByGrade: updatedProgressByGrade,
        earnedBadges: earnedBadges,
        overallProgress: overallProgress,
        hasMathKidBadge: hasMathKidBadge,
        lastUpdated: DateTime.now(),
      );

      // Sauvegarder dans Firestore
      await saveUserProgress(updatedProgress);
    } catch (e) {
      print('Erreur lors de la mise à jour du résultat: $e');
      rethrow;
    }
  }

  // Calculer la progression par catégorie
  Map<String, double> _calculateProgressByCategory(Map<String, int> results) {
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
        totalExercisesByCategory[category] =
            totalExercisesByCategory[category]! + exercises.length;
      });
    });

    // Calculer les réponses correctes
    staticExercises.forEach((grade, categories) {
      categories.forEach((category, exercises) {
        for (var exercise in exercises) {
          int? userAnswerIndex = results[exercise.question];
          if (userAnswerIndex != null && userAnswerIndex == exercise.correctAnswer) {
            correctExercisesByCategory[category] =
                correctExercisesByCategory[category]! + 1;
          }
        }
      });
    });

    // Calculer le pourcentage de progression
    totalExercisesByCategory.forEach((category, total) {
      progress[category] = total > 0
          ? correctExercisesByCategory[category]! / total
          : 0.0;
    });

    return progress;
  }

  // Calculer la progression par niveau
  Map<String, double> _calculateProgressByGrade(Map<String, int> results) {
    Map<String, double> progress = {};
    Map<String, int> totalExercisesByGrade = {};
    Map<String, int> correctExercisesByGrade = {};

    // Initialiser les compteurs
    staticExercises.forEach((grade, categories) {
      totalExercisesByGrade[grade] = 0;
      correctExercisesByGrade[grade] = 0;

      categories.forEach((category, exercises) {
        totalExercisesByGrade[grade] =
            totalExercisesByGrade[grade]! + exercises.length;
      });
    });

    // Calculer les réponses correctes
    staticExercises.forEach((grade, categories) {
      categories.forEach((category, exercises) {
        for (var exercise in exercises) {
          int? userAnswerIndex = results[exercise.question];
          if (userAnswerIndex != null && userAnswerIndex == exercise.correctAnswer) {
            correctExercisesByGrade[grade] =
                correctExercisesByGrade[grade]! + 1;
          }
        }
      });
    });

    // Calculer le pourcentage de progression
    totalExercisesByGrade.forEach((grade, total) {
      progress[grade] = total > 0
          ? correctExercisesByGrade[grade]! / total
          : 0.0;
    });

    return progress;
  }

  // Calculer la progression globale
  double _calculateOverallProgress(Map<String, double> progressByCategory) {
    if (progressByCategory.isEmpty) return 0.0;

    double totalProgress = progressByCategory.values.fold(
      0.0,
          (sum, value) => sum + value,
    );
    return totalProgress / progressByCategory.length;
  }

  // Calculer les badges obtenus (70% minimum pour obtenir un badge)
  List<String> _calculateEarnedBadges(Map<String, double> progressByCategory) {
    return progressByCategory.entries
        .where((entry) => entry.value >= 0.7)
        .map((entry) => entry.key)
        .toList();
  }

  // Obtenir la réponse de l'utilisateur pour une question spécifique
  Future<int?> getAnswer(String userId, String question) async {
    try {
      final progress = await getUserProgress(userId);
      return progress?.results[question];
    } catch (e) {
      print('Erreur lors de la récupération de la réponse: $e');
      return null;
    }
  }

  // Réinitialiser la progression d'un utilisateur (utile pour les tests)
  Future<void> resetProgress(String userId) async {
    try {
      await _firestore
          .collection('userProgress')
          .doc(userId)
          .set(UserProgress.empty(userId).toFirestore());
    } catch (e) {
      print('Erreur lors de la réinitialisation de la progression: $e');
      rethrow;
    }
  }

  // Stream pour écouter les changements de progression en temps réel
  Stream<UserProgress?> watchUserProgress(String userId) {
    return _firestore
        .collection('userProgress')
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        return UserProgress.fromFirestore(snapshot.data()!, userId);
      }
      return UserProgress.empty(userId);
    });
  }
}