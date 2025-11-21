import 'package:cloud_firestore/cloud_firestore.dart';

class UserProgress {
  final String userId;
  final Map<String, int> results; // Question -> Index de réponse
  final Map<String, double> progressByCategory; // Catégorie -> Progression (0.0 - 1.0)
  final Map<String, double> progressByGrade; // Niveau -> Progression (0.0 - 1.0)
  final List<String> earnedBadges; // Liste des badges obtenus
  final double overallProgress; // Progression globale (0.0 - 1.0)
  final bool hasMathKidBadge; // Badge MathKid (80%+)
  final DateTime lastUpdated;

  UserProgress({
    required this.userId,
    required this.results,
    required this.progressByCategory,
    required this.progressByGrade,
    required this.earnedBadges,
    required this.overallProgress,
    required this.hasMathKidBadge,
    required this.lastUpdated,
  });

  // Convertir en Map pour Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'results': results,
      'progressByCategory': progressByCategory,
      'progressByGrade': progressByGrade,
      'earnedBadges': earnedBadges,
      'overallProgress': overallProgress,
      'hasMathKidBadge': hasMathKidBadge,
      'lastUpdated': Timestamp.fromDate(lastUpdated),
    };
  }

  // Créer depuis Firestore
  factory UserProgress.fromFirestore(Map<String, dynamic> data, String userId) {
    return UserProgress(
      userId: userId,
      results: Map<String, int>.from(data['results'] ?? {}),
      progressByCategory: Map<String, double>.from(
        (data['progressByCategory'] as Map<String, dynamic>?)?.map(
              (key, value) => MapEntry(key, (value as num).toDouble()),
        ) ?? {},
      ),
      progressByGrade: Map<String, double>.from(
        (data['progressByGrade'] as Map<String, dynamic>?)?.map(
              (key, value) => MapEntry(key, (value as num).toDouble()),
        ) ?? {},
      ),
      earnedBadges: List<String>.from(data['earnedBadges'] ?? []),
      overallProgress: (data['overallProgress'] as num?)?.toDouble() ?? 0.0,
      hasMathKidBadge: data['hasMathKidBadge'] as bool? ?? false,
      lastUpdated: (data['lastUpdated'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // Créer une instance vide pour un nouvel utilisateur
  factory UserProgress.empty(String userId) {
    return UserProgress(
      userId: userId,
      results: {},
      progressByCategory: {},
      progressByGrade: {},
      earnedBadges: [],
      overallProgress: 0.0,
      hasMathKidBadge: false,
      lastUpdated: DateTime.now(),
    );
  }

  // Créer une copie avec des modifications
  UserProgress copyWith({
    String? userId,
    Map<String, int>? results,
    Map<String, double>? progressByCategory,
    Map<String, double>? progressByGrade,
    List<String>? earnedBadges,
    double? overallProgress,
    bool? hasMathKidBadge,
    DateTime? lastUpdated,
  }) {
    return UserProgress(
      userId: userId ?? this.userId,
      results: results ?? this.results,
      progressByCategory: progressByCategory ?? this.progressByCategory,
      progressByGrade: progressByGrade ?? this.progressByGrade,
      earnedBadges: earnedBadges ?? this.earnedBadges,
      overallProgress: overallProgress ?? this.overallProgress,
      hasMathKidBadge: hasMathKidBadge ?? this.hasMathKidBadge,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  // Méthode pour vérifier si un badge spécifique est obtenu
  bool hasBadge(String badgeName) {
    return earnedBadges.contains(badgeName);
  }

  // Méthode pour obtenir le nombre de badges obtenus
  int get totalBadgesEarned => earnedBadges.length;

  // Méthode pour vérifier si toutes les catégories sont complétées
  bool get isAllCategoriesCompleted {
    if (progressByCategory.isEmpty) return false;
    return progressByCategory.values.every((progress) => progress >= 1.0);
  }
}